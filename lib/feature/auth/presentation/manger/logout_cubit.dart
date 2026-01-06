import 'package:appartment/feature/auth/presentation/manger/logout_state.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LoginRepo _logoutRepo;

  LogoutCubit(this._logoutRepo) : super(LogoutInitial());

  Future<void> performLogout(BuildContext context) async {
    emit(LogoutLoading());
    try {
      final message = await _logoutRepo.logout();

      emit(LogoutSuccess(message));
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
