part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, unauthenticated, authenticated, error }

final class AuthState extends Equatable {
  const AuthState(
      {this.email = '',
      this.password = '',
      this.status = AuthStatus.initial,
      this.errorMessage});

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  final String email;
  final String password;
  final AuthStatus status;
  final String? errorMessage;

  AuthState copyWith({
    String? email,
    String? password,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
