import 'package:appartment/feature/auth/presentation/manger/google_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginCubit extends Cubit<GoogleLoginState> {
  GoogleLoginCubit() : super(GoogleLoginInitial());
  Future<void> loginWithGoogle() async {}
}
