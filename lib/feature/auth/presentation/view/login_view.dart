import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/style/styles.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/core/utils/assetimage.dart';
import 'package:appartment/core/utils/const.dart';
import 'package:appartment/core/widget/background_viwe.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/custom_field.dart';
import 'package:appartment/feature/CompleteProfile/presentation/manger/cubit/complet_profile_cubit.dart';
import 'package:appartment/feature/CompleteProfile/presentation/view/complet_profile_view.dart';
import 'package:appartment/feature/CompleteProfile/repo/cmplet_profile_repo.dart';
import 'package:appartment/feature/auth/presentation/manger/google_login_cubit.dart';
import 'package:appartment/feature/auth/presentation/manger/google_login_state.dart';
import 'package:appartment/feature/auth/presentation/manger/login_cubit.dart';
import 'package:appartment/feature/auth/presentation/manger/login_state.dart';
import 'package:appartment/feature/auth/presentation/view/register_view.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';
import 'package:appartment/feature/home/presentation/view/home_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: '0998877');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit(LoginRepo(ApiService()))),
        BlocProvider(create: (context) => GoogleLoginCubit()),
      ],
      child: BackgroundWrapper(
        // ⬅️ استخدام ويدجت الخلفية
        backgroundImagePath:
            Assets.assetsImagesPhoto20250924144805RemovebgPreview,
        applyOverlay: true,
        child: LoginViewBody(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
        ),
      ),
    );
  }
}

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey,
       _emailController = emailController,
       _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidthRegster),

          child: ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(
              overscroll: false,
              scrollbars: false,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 160,
                      color: Palette.backgroundColor,
                    ),
                  ),

                  const Text(
                    'ادخل الى حسابك',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 3. حقل الإيميل
                  CustomTextField(
                    controller: _emailController,
                    labelText: ' رقم هاتفك',
                    hintText: 'أدخل الرقم',
                    prefixIcon: const Icon(Icons.email, color: Palette.primary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء عدم ترك حقل الرقم فارغ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 4. حقل كلمة المرور
                  CustomTextField(
                    controller: _passwordController,
                    obscureText: true,
                    labelText: 'كلمة المرور',
                    hintText: 'أدخل كلمة المرور الخاصة بك',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Palette.primary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء عدم ترك حقل كلمة المرور فارغ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {},

                    child: Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: Styles.textStyle16.copyWith(
                          color: Palette.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) async {
                      if (state is LoginSuccess) {
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => CompleteProfileCubit(
                                ProfileRepo(ApiService()),
                              ),
                              child: CompleteProfileView(),
                            ),
                          ),
                        );
                        showCustomSnackBar(
                          context,
                          'تم تسجيل الدخول بنجاح',
                          color: Palette.success,
                        );
                      } else if (state is LoginFailure) {
                        showCustomSnackBar(
                          context,
                          state.error,
                          color: Palette.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      final bool isLoading = state is LoginLoading;
                      return CustomButton(
                        onTap: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginCubit>().login(
                                    usernameOrPhone: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        text: isLoading ? 'جاري الدخول...' : 'تسجيل الدخول',
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // 6. زر Google Login الجميل
                  BlocConsumer<GoogleLoginCubit, GoogleLoginState>(
                    listener: (context, state) {
                      if (state is GoogleLoginSuccess) {
                        showCustomSnackBar(
                          context,
                          'تم تسجيل الدخول بنجاح عبر Google',
                          color: Palette.success,
                        );
                      } else if (state is GoogleLoginFailure) {
                        showCustomSnackBar(
                          context,
                          'فشل تسجيل الدخول عبر Google: ${state.error}',
                          color: Palette.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      final bool isGoogleLoading = state is GoogleLoginLoading;
                      return Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: isGoogleLoading
                              ? null
                              : () {
                                  // context
                                  //     .read<GoogleLoginCubit>()
                                  //     .loginWithGoogle();
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isGoogleLoading) ...[
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ] else ...[
                                // أيقونة Google
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.g_mobiledata,
                                    color: Color(0xFF4285F4),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              Text(
                                isGoogleLoading
                                    ? 'جاري تسجيل الدخول...'
                                    : 'تسجيل الدخول عبر Google',
                                style: Styles.textStyle18,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  const Divider(color: Colors.white30, height: 40),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterView(),
                        ),
                      );
                    },
                    child: Center(
                      child: const Text(
                        'ليس لديك حساب؟ إنشاء حساب جديد',
                        style: Styles.textStyle18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
