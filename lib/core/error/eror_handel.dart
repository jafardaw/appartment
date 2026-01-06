// في ملف eror_handel.dart
import 'package:dio/dio.dart';

class ErrorHandler implements Exception {
  final String message;

  ErrorHandler(this.message);

  @override
  String toString() => message;

  static Exception handleDioError(DioException e) {
    String errorMessage = "حدث خطأ غير متوقع";

    if (e.type == DioExceptionType.badResponse) {
      errorMessage = extractErrorMessage(e.response);
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = "انتهى وقت الاتصال بالخادم";
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = "انتهى وقت إرسال الطلب إلى الخادم";
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = "انتهى وقت استقبال الرد من الخادم";
          break;
        case DioExceptionType.badCertificate:
          errorMessage = "شهادة الأمان غير صالحة";
          break;
        case DioExceptionType.cancel:
          errorMessage = "تم إلغاء الطلب إلى الخادم";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "خطأ في الاتصال بالخادم. تأكد من اتصالك بالإنترنت.";
          break;
        case DioExceptionType.unknown:
          errorMessage = "فشل الاتصال بالخادم أو مشكلة في الإنترنت.";
          break;
        default:
          errorMessage = "حدث خطأ غير متوقع.";
          break;
      }
    }
    return ErrorHandler(errorMessage);
  }

  static String extractErrorMessage(Response? response) {
    if (response != null && response.data is Map) {
      var responseData = response.data;
      String message = responseData['message'] ?? "حدث خطأ غير متوقع";

      if (responseData.containsKey('errors')) {
        var errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          var firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            message += ": ${firstError.first}";
          }
        }
      }
      return message;
    }
    return "حدث خطأ دون معلومات إضافية";
  }
}
