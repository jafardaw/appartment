import 'package:appartment/core/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // مهم جداً للتميز بين الويب والموبايل

class ProfileRepo {
  final ApiService apiService;

  ProfileRepo(this.apiService);

  Future<Map<String, dynamic>> completeProfile({
    required String firstName,
    required String lastName,
    required String birthDate,
    required XFile idImagePath,
    required XFile profileImagePath,
  }) async {
    // تحويل الملفات إلى تنسيق يفهمه السيرفر حسب المنصة
    MultipartFile idFile;
    MultipartFile profileFile;

    if (kIsWeb) {
      // للويب: نقرأ الملف كـ Bytes
      idFile = MultipartFile.fromBytes(
        await idImagePath.readAsBytes(),
        filename: idImagePath.name,
      );
      profileFile = MultipartFile.fromBytes(
        await profileImagePath.readAsBytes(),
        filename: profileImagePath.name,
      );
    } else {
      // للموبايل: نستخدم المسار المباشر
      idFile = await MultipartFile.fromFile(
        idImagePath.path,
        filename: idImagePath.name,
      );
      profileFile = await MultipartFile.fromFile(
        profileImagePath.path,
        filename: profileImagePath.name,
      );
    }

    FormData formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate,
      'id_image': idFile,
      'profile_image': profileFile,
    });

    final Response response = await apiService.post(
      'complete/profile',
      formData,
    );

    return response.data as Map<String, dynamic>;
  }
}
