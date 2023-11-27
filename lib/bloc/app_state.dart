part of 'app_bloc.dart';

final class AppState extends Equatable {
  const AppState(this.user);
  final User? user;

  @override
  List<Object?> get props => [user];
}

final class AppInitial extends AppState {
  const AppInitial() : super(null);
}

final class Authenticated extends AppState {
  const Authenticated(User user) : super(user);
}

final class Unauthenticated extends AppState {
  const Unauthenticated() : super(null);
}
