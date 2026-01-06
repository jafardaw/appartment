import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/auth/presentation/manger/register_cubit.dart';
import 'package:appartment/feature/auth/presentation/manger/register_state.dart';
import 'package:appartment/feature/auth/presentation/view/verify_email_view.dart'; // تأكد من تغيير الوجهة إذا كان هناك صفحة انتظار موافقة
import 'package:appartment/feature/auth/repo/login_repo.dart';
import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/style/styles.dart';
import 'package:appartment/core/utils/assetimage.dart';
import 'package:appartment/core/utils/const.dart';
import 'package:appartment/core/widget/background_viwe.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/custom_field.dart';
import 'package:appartment/core/widget/error_widget_view.dart';
import 'package:appartment/core/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  // التحكم بالحقول بناءً على متطلبات الـ Cubit
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedRole; // لتخزين الدور (مستأجر، مالك، إلخ)

  final List<String> _roles = [
    'tenant',
    'owner',
  ]; // القيم التي يقبلها السيرفر غالباً

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(LoginRepo(ApiService())),
      child: BackgroundWrapper(
        backgroundImagePath:
            Assets.assetsImagesPhoto20250924144805RemovebgPreview,
        applyOverlay: true,
        child: Scaffold(
          // أضفت Scaffold ليكون التصميم متناسقاً
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: maxWidthRegster),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // أيقونة المنزل كشعار
                      const Icon(
                        Icons.home_work_outlined,
                        size: 120,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'إنشاء حساب جديد',
                        style: Styles.textStyle20,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'الرجاء إدخال البيانات التالية للانضمام إلينا',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // حقل اختيار الدور (Role)
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          labelText: 'نوع الحساب',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'tenant',
                            child: Text('مستأجر'),
                          ),
                          DropdownMenuItem(
                            value: 'owner',
                            child: Text('مالك الوحدة'),
                          ),
                        ],
                        onChanged: (val) => setState(() => _selectedRole = val),
                        validator: (val) =>
                            val == null ? 'الرجاء اختيار نوع الحساب' : null,
                      ),
                      const SizedBox(height: 20),

                      // حقل رقم الهاتف
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'رقم الهاتف',
                        hintText: 'أدخل رقم هاتفك',
                        prefixIcon: const Icon(
                          Icons.phone_android,
                          color: Colors.blueGrey,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال رقم الهاتف';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // حقل كلمة المرور
                      CustomTextField(
                        controller: _passwordController,
                        obscureText: true,
                        labelText: 'كلمة المرور',
                        hintText: 'أدخل كلمة المرور',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Palette.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال كلمة المرور';
                          if (value.length < 6) return 'كلمة المرور قصيرة جداً';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // حقل تأكيد كلمة المرور
                      CustomTextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        labelText: 'تأكيد كلمة المرور',
                        hintText: 'أعد كتابة كلمة المرور',
                        prefixIcon: const Icon(
                          Icons.lock_reset,
                          color: Palette.primary,
                        ),
                        validator: (value) {
                          if (value != _passwordController.text)
                            return 'كلمات المرور غير متطابقة';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // منطق الـ BLoC للزر والحالات
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            showCustomSnackBar(
                              context,
                              state.message,
                              color: Palette.success,
                            );
                            // يمكنك هنا التوجه لصفحة تسجيل الدخول أو صفحة الانتظار
                            Navigator.pop(context);
                          } else if (state is RegisterFailure) {
                            showCustomSnackBar(
                              context,
                              state.error,
                              color: Palette.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is RegisterLoading) {
                            return const LoadingViewWidget();
                          }

                          return CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                  role: _selectedRole!,
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text,
                                  passwordConfirmation:
                                      _confirmPasswordController.text,
                                );
                              }
                            },
                            text: 'إنشاء الحساب',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
