import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/booking_state.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  final HomeRepo repo;
  BookingCubit(this.repo) : super(BookingInitial());

  Future<void> createBooking(int id, String start, String end) async {
    emit(BookingLoading());
    try {
      await repo.bookApartment(apartmentId: id, startDate: start, endDate: end);
      emit(
        BookingSuccess("تم حجز الشقة للمدة التي حددتها، الرجاء عدم التأخر."),
      );
    } catch (e) {
      emit(BookingFailure("فشل الحجز: تأكد من البيانات وحاول مجدداً"));
    }
  }
}
