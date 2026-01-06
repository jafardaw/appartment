// lib/features/login/logic/login_state.dart (أو حيثما تضع ملف الـ State)

import 'package:appartment/feature/auth/data/model/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  // استخدام النموذج بدلاً من حقلين منفصلين
  final LoginResponseModel responseModel;

  LoginSuccess(this.responseModel);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
