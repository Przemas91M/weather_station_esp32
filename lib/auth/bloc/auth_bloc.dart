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
        super(authRepository.currentUser == null
            ? Unauthenticated()
            : Authenticated(authRepository.user!)) {
    on<InitializeApp>(_initializeApp);
    on<AppUserChanged>(_userChanged);
    on<SignInRequested>(_userSignIn);
    on<SignUpRequested>(_userSignUp);
    on<OpenLoginScreen>(_openLoginScreen);
    on<OpenNewUserScreen>(_openNewUserScreen);
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  FutureOr<void> _initializeApp(InitializeApp event, Emitter<AuthState> emit) {
    _authSubscription!.cancel();
    _authSubscription = _authRepository.userStream
        .listen((user) => add(AppUserChanged(user: user)));
  }

  FutureOr<void> _userChanged(AppUserChanged event, Emitter<AuthState> emit) {
    emit(event.user == null ? Unauthenticated() : Authenticated(event.user));
  }

  FutureOr<void> _userSignIn(SignInRequested event, Emitter<AuthState> emit) {
    _authRepository.signInWithEmailPassword(
        email: event.email, password: event.password);
  }

  FutureOr<void> _userSignUp(SignUpRequested event, Emitter<AuthState> emit) {
    _authRepository.signUpWithEmailPassword(
        email: event.email,
        password: event.password,
        displayName: event.displayName);
  }

  FutureOr<void> _openLoginScreen(
      OpenLoginScreen event, Emitter<AuthState> emit) {
    emit(SignIn());
  }

  FutureOr<void> _openNewUserScreen(
      OpenNewUserScreen event, Emitter<AuthState> emit) {
    emit(SignUp());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
