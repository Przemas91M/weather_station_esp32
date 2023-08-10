part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Loading extends AuthState {}

class Authenticated extends AuthState {
  final User? user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class SignIn extends AuthState {}

class SignUp extends AuthState {}
