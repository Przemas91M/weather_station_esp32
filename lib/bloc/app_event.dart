part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);
  final User? user;
}

class AppLogOutRequested extends AppEvent {}

class OpenSettingsScreen extends AppEvent {}

class RefreshUser extends AppEvent {}
