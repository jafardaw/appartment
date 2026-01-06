import 'package:appartment/feature/auth/presentation/manger/verify_email_state.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final LoginRepo _verifyEmailRepo;

  VerifyEmailCubit(this._verifyEmailRepo) : super(VerifyEmailInitial());

  Future<void> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    emit(VerifyEmailLoading());
    try {
      final message = await _verifyEmailRepo.verifyEmail(
        email: email,
        verificationCode: verificationCode,
      );
      emit(VerifyEmailSuccess(message));
    } catch (e) {
      emit(VerifyEmailFailure(e.toString()));
    }
  }
}
