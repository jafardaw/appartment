import 'package:appartment/feature/auth/presentation/manger/register_state.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final LoginRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  Future<void> register({
    required String role,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(RegisterLoading());
    try {
      // **التعديل هنا:** المتغير الآن يستقبل user_id كـ int
      await _registerRepo.register(
        role: role,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // بما أن الـ Repo أصبح يرجع user_id فقط، نستخدم رسالة ثابتة للنجاح
      const successMessage =
          "تم إنشاء الحساب بنجاح،الرجاء الانتظار الموارفقة  من  الادمن.";

      // **إصدار حالة النجاح مع الرسالة و userId الجديد**
      emit(RegisterSuccess(successMessage));
    } catch (e) {
      // تبقى معالجة الأخطاء كما هي
      emit(RegisterFailure(e.toString()));
    }
  }
}
