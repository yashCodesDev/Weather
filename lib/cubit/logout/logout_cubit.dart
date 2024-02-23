import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:weather_service/data/services/auth_service.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());
  final AuthService _authService = AuthService();

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await _authService.signOut();
      emit(LogoutSuccess());
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      emit(LogoutFailure(e.toString()));
    }
  }
}
