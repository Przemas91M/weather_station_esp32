part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class Authenticated extends AppState {
  const Authenticated(this.user);
  final User user;
}

class Unauthenticated extends AppState {}
