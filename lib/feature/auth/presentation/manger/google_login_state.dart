abstract class GoogleLoginState {}

class GoogleLoginInitial extends GoogleLoginState {}

class GoogleLoginLoading extends GoogleLoginState {}

class GoogleLoginSuccess extends GoogleLoginState {
  final String token;
  final dynamic user;

  GoogleLoginSuccess({required this.token, required this.user});
}

class GoogleLoginFailure extends GoogleLoginState {
  final String error;

  GoogleLoginFailure(this.error);
}
