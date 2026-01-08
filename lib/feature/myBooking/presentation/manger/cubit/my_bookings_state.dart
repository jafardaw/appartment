// booking_state.dart
import 'package:appartment/feature/myBooking/data/model/my_booking_model.dart';
import 'package:appartment/feature/myBooking/repo/my_booking_repo.dart';

abstract class MyBookingsState {}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsSuccess extends MyBookingsState {
  final BookingResponseModel responseModel;
  MyBookingsSuccess(this.responseModel);
}

class MyBookingsFailure extends MyBookingsState {
  final String error;
  MyBookingsFailure(this.error);
}
