import 'package:appartment/core/error/eror_handel.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/auth/data/model/login_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<LoginResponseModel> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('login', {
        "phone": usernameOrPhone,
        "password": password,
      });

      final data = response.data;

      final responseModel = LoginResponseModel.fromJson(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseModel.token);
      await prefs.setString('role', responseModel.user.role);

      return responseModel;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow;
    }
  }

  Future<String> register({
    required String role,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.post('register', {
        "role": role,
        "phone": phone,
        "password": password,
        "password_confirmation": passwordConfirmation,
      });

      final data = response.data;

      return "تم  التسجيل بنجاح الرجاء الانتظار  الموافقة من  الادمن ";
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in RegisterRepo: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e); // التعامل مع أخطاء Dio
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in RegisterRepo: $e');
      }
      rethrow;
    }
  }

  Future<String> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    try {
      final response = await _apiService.post('auth/verify-otp', {
        "contact": email,
        "code": verificationCode,
      });

      final data = response.data;

      return data['message'];
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in VerifyEmailRepo: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in VerifyEmailRepo: $e');
      }
      rethrow;
    }
  }

  Future<String> resendCode({required int userId}) async {
    try {
      final response = await _apiService.post('auth/resend-otp-code', {
        "user_id": userId,
      });

      final data = response.data;

      if (data['status'] == "success") {
        return data['message'];
      } else {
        throw Exception(data['message'] ?? 'فشل في إعادة إرسال كود التحقق.');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in ResendCodeRepo: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in ResendCodeRepo: $e');
      }
      rethrow;
    }
  }

  Future<String> logout() async {
    // 🔑 الخطوة الأولى والأهم: حذف التوكن محلياً على الفور
    // هذا يضمن خروج المستخدم فوراً من التطبيق حتى لو فشل طلب الـ API
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // إزالة أي بيانات مستخدم مخزنة أخرى إذا لزم الأمر
    // await prefs.remove('user_data');

    // إعداد رسالة افتراضية
    String resultMessage = 'تم تسجيل الخروج بنجاح.';

    try {
      // 2. محاولة إخبار الخادم بإنهاء الجلسة (لإبطال التوكن في قاعدة البيانات)
      final response = await _apiService.postwithOutData(
        'auth/logout',
      ); // استخدام دالة postwithOutData

      final data = response.data;

      // تحقق من الرد القياسي (إذا كان الخادم يرجع رسالة نجاح)
      if (data['status'] == "success" || data['message'] != null) {
        resultMessage = data['message'] ?? 'تم تسجيل الخروج من الخادم بنجاح.';
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught during logout: ${e.message}');
      }
      // لا نحتاج لرفع خطأ هنا! الأهم هو أننا حذفنا التوكن محلياً.
      // الـ 401 الذي أرسلته (غير مصرح بالدخول) يعني أن المستخدم غير مسجل، أو أن التوكن تم حذفه مسبقاً،
      // لذا لا يؤثر على نجاح عملية تسجيل الخروج من ناحية المستخدم.
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught during logout: $e');
      }
    }

    return resultMessage;
  }
}
