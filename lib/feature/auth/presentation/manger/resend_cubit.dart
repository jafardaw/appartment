import 'package:appartment/feature/auth/presentation/manger/resend_code_state.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ResendCodeCubit extends Cubit<ResendCodeState> {
  final LoginRepo _resendCodeRepo;

  ResendCodeCubit(this._resendCodeRepo) : super(ResendCodeInitial());

  Future<void> resendCode({required int userId}) async {
    emit(ResendCodeLoading());
    try {
      final message = await _resendCodeRepo.resendCode(userId: userId);
      emit(ResendCodeSuccess(message));
    } catch (e) {
      emit(ResendCodeFailure(e.toString()));
    }
  }
}
