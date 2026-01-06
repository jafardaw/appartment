abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message; // لحمل رسالة النجاح

  RegisterSuccess(this.message);
}

class RegisterFailure extends RegisterState {
  final String error; // لحمل رسالة الخطأ
  RegisterFailure(this.error);
}
