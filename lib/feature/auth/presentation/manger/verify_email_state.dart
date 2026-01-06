abstract class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailSuccess extends VerifyEmailState {
  final String responseModel;
  VerifyEmailSuccess(this.responseModel);
}

class VerifyEmailFailure extends VerifyEmailState {
  final String error;
  VerifyEmailFailure(this.error);
}
