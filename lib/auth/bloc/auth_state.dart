part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, unauthenticated, authenticated, error }

final class AuthState extends Equatable {
  const AuthState(
      {this.email = '',
      this.password = '',
      this.displayName = '',
      this.status = AuthStatus.initial,
      this.errorMessage});

  @override
  List<Object?> get props =>
      [email, password, displayName, status, errorMessage];

  final String email;
  final String password;
  final String displayName;
  final AuthStatus status;
  final String? errorMessage;

  AuthState copyWith({
    String? email,
    String? password,
    String? displayName,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        displayName: displayName ?? this.displayName,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
