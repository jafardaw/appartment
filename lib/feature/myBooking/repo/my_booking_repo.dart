// booking_repo.dart
import 'package:appartment/core/error/eror_handel.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/myBooking/data/model/my_booking_model.dart';
import 'package:dio/dio.dart';

// booking_repo.dart
class BookingRepo {
  final ApiService _apiService;

  BookingRepo(this._apiService);

  Future<BookingResponseModel> getMyBookings() async {
    try {
      // الـ response هنا من نوع Response<dynamic>
      final response = await _apiService.get('mybooking');

      // الإصلاح: مرر response.data بدلاً من response
      final data = response.data;

      // الآن نقوم بتحويل البيانات إلى موديل
      return BookingResponseModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rateBooking({
    required int bookingId,
    required double rating,
  }) async {
    try {
      await _apiService.post('booking/$bookingId/review', {"rating": rating});
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
