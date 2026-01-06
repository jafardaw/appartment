// lib/features/login/logic/login_cubit.dart

import 'package:appartment/feature/auth/presentation/manger/login_state.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      // الـ repo الآن يرجع LoginResponseModel
      final responseModel = await _loginRepo.login(
        usernameOrPhone: usernameOrPhone,
        password: password,
      );

      // تمرير النموذج بالكامل إلى حالة النجاح
      emit(LoginSuccess(responseModel));
    } catch (e) {
      // ... (التعامل مع الخطأ)
      emit(LoginFailure(e.toString()));
    }
  }
}
