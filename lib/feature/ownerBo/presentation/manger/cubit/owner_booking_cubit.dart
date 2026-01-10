import 'package:appartment/feature/myBooking/repo/my_booking_repo.dart';
import 'package:appartment/feature/ownerBo/presentation/manger/cubit/owner_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerBookingsCubit extends Cubit<OwnerBookingsState> {
  final BookingRepo repo; // أو الـ Repo المخصص للحجوزات
  OwnerBookingsCubit(this.repo) : super(OwnerBookingsInitial());

  Future<void> fetchOwnerBookings() async {
    emit(OwnerBookingsLoading());
    try {
      final bookings = await repo.getOwnerBookings();
      emit(OwnerBookingsSuccess(bookings));
    } catch (e) {
      emit(OwnerBookingsFailure("فشل تحميل الحجوزات"));
    }
  }

  // داخل OwnerBookingsCubit
  Future<void> updateBookingStatus(int bookingId, bool isApprove) async {
    // لا نغير الحالة لـ Loading كامل الصفحة حتى لا تختفي القائمة
    // يمكن إضافة حالة خاصة بالـ Buttons إذا أردت
    try {
      if (isApprove) {
        await repo.approveBooking(bookingId);
      } else {
        await repo.rejectBooking(bookingId);
      }
      // إعادة جلب البيانات لتحديث القائمة والحالات
      await fetchOwnerBookings();
    } catch (e) {
      emit(OwnerBookingsFailure('تم الارسال بنجاح'));
    }
  }
}
