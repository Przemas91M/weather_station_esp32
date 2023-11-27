import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AppInitial()) {
    on<_AppUserChanged>(_userChanged);
    on<AppLogOutRequested>(_appLogoutRequested);
    on<RefreshUser>(_refreshUser);
    _userSubscription =
        _authRepository.userStream.listen((user) => add(_AppUserChanged(user)));
  }
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  FutureOr<void> _userChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(event.user == null
        ? const Unauthenticated()
        : Authenticated(event.user!));
  }

  FutureOr<void> _appLogoutRequested(
      AppLogOutRequested event, Emitter<AppState> emit) {
    _authRepository.logOut();
  }

  FutureOr<void> _refreshUser(RefreshUser event, Emitter<AppState> emit) async {
    User? user = await _authRepository.refreshUser();
    emit(Authenticated(user!));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
