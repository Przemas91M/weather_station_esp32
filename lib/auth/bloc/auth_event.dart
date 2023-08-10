part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class InitializeApp extends AuthEvent {}

class OpenNewUserScreen extends AuthEvent {}

class OpenLoginScreen extends AuthEvent {}

class AppUserChanged extends AuthEvent {
  const AppUserChanged({required this.user});
  final User? user;
}

class SignInRequested extends AuthEvent {
  const SignInRequested({required this.email, required this.password});
  final String email;
  final String password;
}

class SignUpRequested extends AuthEvent {
  const SignUpRequested(
      {required this.email, required this.password, required this.displayName});
  final String email;
  final String password;
  final String displayName;
}

class LogOutRequested extends AuthEvent {}
