import 'dart:io';

import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/custom_field.dart';
import 'package:appartment/feature/CompleteProfile/presentation/manger/cubit/complet_profile_cubit.dart';
import 'package:appartment/feature/CompleteProfile/presentation/manger/cubit/complet_profile_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _dateController = TextEditingController();

  // استخدام XFile لضمان التوافق مع الويب والأندرويد
  XFile? _idImageFile;
  XFile? _profileImageFile;

  Future<void> _pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          _profileImageFile = pickedFile;
        } else {
          _idImageFile = pickedFile;
        }
      });
    }
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // بما أنك تستخدم BackgroundWrapper عادةً، تأكد من إحاطة هذه الصفحة به في الـ Route
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'إكمال البيانات الشخصية',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.white.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      const Text(
                        'يرجى تزويدنا بالمعلومات التالية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 25),

                      CustomTextField(
                        controller: _fNameController,
                        labelText: 'الاسم الأول',
                        hintText: 'أدخل اسمك الأول',
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: _lNameController,
                        labelText: 'الكنية',
                        hintText: 'أدخل الكنية',
                        prefixIcon: const Icon(Icons.people_outline),
                        validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: _dateController,
                        labelText: 'تاريخ الميلاد',
                        hintText: 'YYYY-MM-DD',
                        prefixIcon: const Icon(Icons.cake_outlined),
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _dateController.text = picked.toString().split(
                                ' ',
                              )[0];
                            });
                          }
                        },
                        validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
                      ),
                      const SizedBox(height: 20),

                      // اختيار الصور
                      Row(
                        children: [
                          Expanded(
                            child: _buildImageTile(
                              'الصورة الشخصية',
                              _profileImageFile?.path,
                              () => _pickImage(true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildImageTile(
                              'صورة الهوية',
                              _idImageFile?.path,
                              () => _pickImage(false),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
                        listener: (context, state) {
                          if (state is CompleteProfileSuccess) {
                            showCustomSnackBar(
                              context,
                              state.message,
                              color: Colors.green,
                            );
                            // Navigator.pushReplacementNamed(context, '/home');
                          } else if (state is CompleteProfileFailure) {
                            showCustomSnackBar(
                              context,
                              state.error,
                              color: Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is CompleteProfileLoading) {
                            return const CircularProgressIndicator();
                          }
                          return CustomButton(
                            text: 'إرسال البيانات',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (_idImageFile == null ||
                                    _profileImageFile == null) {
                                  showCustomSnackBar(
                                    context,
                                    'يرجى اختيار الصور المطلوبة',
                                    color: Colors.orange,
                                  );
                                  return;
                                }
                                context
                                    .read<CompleteProfileCubit>()
                                    .completeProfile(
                                      fName: _fNameController.text,
                                      lName: _lNameController.text,
                                      bDate: _dateController.text,
                                      idImg: _idImageFile!,
                                      pImg: _profileImageFile!,
                                    );
                              }
                            },
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

  Widget _buildImageTile(String label, String? path, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Palette.primary.withOpacity(0.5)),
            ),
            child: path == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 35,
                        color: Palette.primary,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'إضافة صورة',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kIsWeb
                        ? Image.network(
                            path,
                            fit: BoxFit.cover,
                          ) // للويب نستخدم network
                        : Image.file(
                            File(path),
                            fit: BoxFit.cover,
                          ), // للموبايل نستخدم file
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
