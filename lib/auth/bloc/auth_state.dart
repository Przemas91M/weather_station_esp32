part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, unauthenticated, authenticated, error }

final class AuthState extends Equatable {
  const AuthState(
      {this.email = '',
      this.password = '',
      this.confirmedPassword = '',
      this.displayName = '',
      this.status = AuthStatus.initial,
      this.isValidated = false,
      this.errorMessage});

  @override
  List<Object?> get props =>
      [email, password, confirmedPassword, displayName, status, errorMessage];

  final String email;
  final String password;
  final String confirmedPassword;
  final String displayName;
  final AuthStatus status;
  final bool isValidated;
  final String? errorMessage;

  AuthState copyWith({
    String? email,
    String? password,
    String? confirmedPassword,
    String? displayName,
    AuthStatus? status,
    bool? isValidated,
    String? errorMessage,
  }) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        displayName: displayName ?? this.displayName,
        status: status ?? this.status,
        isValidated: isValidated ?? this.isValidated,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
