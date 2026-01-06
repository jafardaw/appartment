import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/style/styles.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/core/utils/assetimage.dart';
import 'package:appartment/core/utils/const.dart';
import 'package:appartment/core/widget/background_viwe.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/error_widget_view.dart';
import 'package:appartment/core/widget/loading_view.dart';
import 'package:appartment/feature/auth/presentation/manger/resend_code_state.dart';
import 'package:appartment/feature/auth/presentation/manger/resend_cubit.dart';
import 'package:appartment/feature/auth/presentation/manger/verify_email_cubit.dart';
import 'package:appartment/feature/auth/presentation/manger/verify_email_state.dart';
import 'package:appartment/feature/auth/presentation/view/login_view.dart';
import 'package:appartment/feature/auth/repo/login_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailView extends StatelessWidget {
  final String email;

  const VerifyEmailView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    const String backgroundImagePath =
        Assets.assetsImagesPhoto20250924144805RemovebgPreview;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VerifyEmailCubit(LoginRepo(ApiService())),
        ),
        BlocProvider(
          create: (context) => ResendCodeCubit(LoginRepo(ApiService())),
        ),
      ],
      child: BackgroundWrapper(
        backgroundImagePath: backgroundImagePath,
        applyOverlay: true,
        child: VerifyEmailViewBody(emil: email),
      ),
    );
  }
}

class VerifyEmailViewBody extends StatefulWidget {
  final String emil;

  const VerifyEmailViewBody({super.key, required this.emil});

  @override
  State<VerifyEmailViewBody> createState() => _VerifyEmailViewBodyState();
}

class _VerifyEmailViewBodyState extends State<VerifyEmailViewBody> {
  final _formKey = GlobalKey<FormState>();
  String _currentCode = '';
  // String _reverseString(String input) {
  //   return input.split('').reversed.join('');
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(
          overscroll: false,
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidthRegster),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    Assets.assetsImagesPhoto20250924144805RemovebgPreview,
                    height: 270,
                    // إضافة لون أبيض شفاف لجعله يظهر على الخلفية الداكنة
                  ),
                ),

                const Text(
                  'أدخل رمز التحقق',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // تغيير لون النص إلى الأبيض
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Text(
                  'تم إرسال رمز مكون من 6 أرقام إلى بريدك الإلكتروني',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70, // تغيير لون النص إلى الأبيض الشفاف
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          inactiveColor: Colors.white54, // لون فاتح
                          activeColor: Palette.primary,
                          selectedColor: Palette.primary.withValues(alpha: 0.5),
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _currentCode = value;
                        },
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "الرجاء إدخال الرمز كاملاً";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                  listener: (context, state) {
                    if (state is VerifyEmailSuccess) {
                      // if (widget.chek == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                      showCustomSnackBar(
                        context,
                        'تم تفعيل الحساب بنجاح',
                        color: Palette.success,
                      );
                      // } else {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           ResetPassowrdView(codeController: _currentCode),
                      //     ),
                      //   );
                      //   showCustomSnackBar(
                      //     context,
                      //     'تم التحقق  بنجاح ادخل  كلمة  سر جديدة ',
                      //     color: Palette.success,
                      //   );
                      // }
                    } else if (state is VerifyEmailFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is VerifyEmailLoading) {
                      return LoadingViewWidget();
                    }
                    if (state is VerifyEmailFailure) {
                      return ShowErrorWidgetView.inlineError(
                        errorMessage: state.error,
                      );
                    }

                    return CustomButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          context.read<VerifyEmailCubit>().verifyEmail(
                            email: widget.emil,
                            verificationCode: _currentCode,
                          );
                        }
                      },
                      text: 'تأكيد الحساب',
                    );
                  },
                ),

                const SizedBox(height: 40),

                // 2. BlocConsumer جديد لزر إعادة إرسال الكود
                BlocConsumer<ResendCodeCubit, ResendCodeState>(
                  listener: (context, state) {
                    if (state is ResendCodeSuccess) {
                      showCustomSnackBar(
                        context,
                        state.message,
                        color: Palette.success,
                      );
                    } else if (state is ResendCodeFailure) {
                      showCustomSnackBar(
                        context,
                        state.error,
                        color: Palette.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is ResendCodeLoading;

                    return Center(
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // context.read<ResendCodeCubit>().resendCode(
                                //   userId: widget.userId,
                                // );
                              },
                        child: isLoading
                            ? LoadingViewWidget()
                            : Text(
                                'لم يصلني الرمز إعادة الإرسال؟ 🤔',
                                style: Styles.textStyle16.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
