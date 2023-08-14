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

class DisplayNameChanged extends AuthEvent {
  const DisplayNameChanged({required this.displayName});
  final String displayName;
}

class EmailChanged extends AuthEvent {
  const EmailChanged({required this.email});
  final String email;
}

class PasswordChanged extends AuthEvent {
  const PasswordChanged({required this.password});
  final String password;
}

class ConfirmPasswordChanged extends AuthEvent {
  const ConfirmPasswordChanged({required this.confirmPassword});
  final String confirmPassword;
}

class SignInRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {}

class LogOutRequested extends AuthEvent {}
