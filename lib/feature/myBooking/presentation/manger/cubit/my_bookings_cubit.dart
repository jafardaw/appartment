import 'package:appartment/feature/myBooking/presentation/manger/cubit/my_bookings_state.dart';
import 'package:appartment/feature/myBooking/repo/my_booking_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final BookingRepo _bookingRepo;

  MyBookingsCubit(this._bookingRepo) : super(MyBookingsInitial());

  Future<void> fetchBookings() async {
    emit(MyBookingsLoading());
    try {
      final response = await _bookingRepo.getMyBookings();
      emit(MyBookingsSuccess(response));
    } catch (e) {
      emit(MyBookingsFailure(e.toString()));
    }
  }

  Future<void> addReview(int bookingId, double rating) async {
    // يمكن إظهار Loading بسيط هنا أو استخدامه مباشرة
    try {
      await _bookingRepo.rateBooking(bookingId: bookingId, rating: rating);
      // يمكنك هنا إعادة جلب البيانات أو إرسال حالة نجاح مخصصة
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBooking(int id, String start, String end) async {
    emit(MyBookingsLoading());
    try {
      await _bookingRepo.updateBooking(id, start, end);
      await fetchBookings(); // إعادة جلب البيانات لتحديث القائمة
    } catch (e) {
      emit(MyBookingsFailure(e.toString()));
    }
  }

  Future<void> deleteBooking(int id) async {
    emit(MyBookingsLoading());
    try {
      await _bookingRepo.cancelBooking(id);
      await fetchBookings();
    } catch (e) {
      emit(MyBookingsFailure(e.toString()));
    }
  }
}
