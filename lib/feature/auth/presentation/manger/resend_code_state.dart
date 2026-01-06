abstract class ResendCodeState {}

class ResendCodeInitial extends ResendCodeState {}

class ResendCodeLoading extends ResendCodeState {}

class ResendCodeSuccess extends ResendCodeState {
  final String message;
  ResendCodeSuccess(this.message);
}

class ResendCodeFailure extends ResendCodeState {
  final String error;
  ResendCodeFailure(this.error);
}
