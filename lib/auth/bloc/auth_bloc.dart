import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<SignInRequested>(_userSignIn);
    on<SignUpRequested>(_userSignUp);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<ConfirmPasswordChanged>(_confirmPasswordChanged);
    on<DisplayNameChanged>(_displayNameChanged);
  }

  final AuthRepository _authRepository;

  FutureOr<void> _displayNameChanged(
      DisplayNameChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(
        displayName: event.displayName, status: AuthStatus.unauthenticated));
  }

  FutureOr<void> _emailChanged(event, Emitter<AuthState> emit) {
    if (_validateEmail(event.email)) {
      emit(state.copyWith(
          email: event.email, status: AuthStatus.unauthenticated));
    }
    emit(state.copyWith(email: event.email, errorMessage: 'Email is invalid!'));
  }

  FutureOr<void> _passwordChanged(
      PasswordChanged event, Emitter<AuthState> emit) {
    emit(event.password.length >= 8
        ? state.copyWith(
            password: event.password, status: AuthStatus.unauthenticated)
        : state.copyWith(
            password: event.password, errorMessage: 'Password too short!'));
  }

  FutureOr<void> _confirmPasswordChanged(
      ConfirmPasswordChanged event, Emitter<AuthState> emit) {
    emit(state.password == event.confirmPassword
        ? state.copyWith(
            confirmedPassword: event.confirmPassword,
            status: AuthStatus.unauthenticated)
        : state.copyWith(
            confirmedPassword: event.confirmPassword,
            errorMessage: 'Passwords not matching!'));
  }

  FutureOr<void> _userSignIn(
      SignInRequested event, Emitter<AuthState> emit) async {
    if (_validateEmail(state.email) && _validatePassword(state.password)) {
      emit(state.copyWith(status: AuthStatus.loading));
      try {
        await _authRepository.signInWithEmailPassword(
            email: state.email, password: state.password);
        emit(state.copyWith(status: AuthStatus.authenticated));
      } on SignInEmailPasswordError catch (e) {
        emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
      } catch (_) {
        emit(state.copyWith(
            status: AuthStatus.error, errorMessage: 'Unknown error!'));
      }
    } else {
      emit(const AuthState(
          status: AuthStatus.error, errorMessage: 'Enter valid credentials!'));
    }
  }

  FutureOr<void> _userSignUp(
      SignUpRequested event, Emitter<AuthState> emit) async {
    if (validateAll()) {
      emit(state.copyWith(status: AuthStatus.loading));
      try {
        await _authRepository.signUpWithEmailPassword(
            email: state.email,
            password: state.password,
            displayName: state.displayName);
        emit(state.copyWith(status: AuthStatus.authenticated));
      } on SignUpEmailPasswordError catch (e) {
        emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
      } catch (_) {
        emit(state.copyWith(
            status: AuthStatus.error, errorMessage: 'Unknown error!'));
      }
    } else {
      emit(const AuthState(
          status: AuthStatus.error, errorMessage: 'Enter valid data!'));
    }
  }

  bool _validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 8;
  }

  bool _validatePasswords(String password, String confirmedPassword) {
    return password.length >= 8 && password == confirmedPassword;
  }

  bool _validateUserName(String username) {
    return username.length >= 3;
  }

  bool validateAll() {
    return _validateEmail(state.email) &&
        _validateUserName(state.displayName) &&
        _validatePasswords(state.password, state.confirmedPassword);
  }
}
