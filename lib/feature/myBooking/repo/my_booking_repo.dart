// booking_repo.dart
import 'package:appartment/core/error/eror_handel.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/myBooking/data/model/my_booking_model.dart';
import 'package:appartment/feature/ownerBo/data/model/owner_boking_model.dart';
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

  Future<List<OwnerBookingModel>> getOwnerBookings() async {
    final data = await _apiService.get("owner/bookings");
    List<OwnerBookingModel> bookings = [];
    for (var item in data.data['bookings']) {
      bookings.add(OwnerBookingModel.fromJson(item));
    }
    return bookings;
  }

  Future<void> approveBooking(int bookingId) async {
    await _apiService.post("owner/booking/$bookingId/approve", {});
  }

  Future<void> rejectBooking(int bookingId) async {
    await _apiService.post("owner/bookings/$bookingId/reject", {});
  }

  Future<void> updateBooking(int id, String startDate, String endDate) async {
    await _apiService.post("booking/$id", {
      "new_start_sate": startDate, // تأكد من الاسم في Backend (date وليس sate)
      "new_end_date": endDate,
      "_method": "PUT",
    });
  }

  Future<void> cancelBooking(int id) async {
    await _apiService.post("booking/$id/cancel", {});
  }
}
