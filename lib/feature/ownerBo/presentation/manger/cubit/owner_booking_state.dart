import 'package:appartment/feature/ownerBo/data/model/owner_boking_model.dart';

abstract class OwnerBookingsState {}

class OwnerBookingsInitial extends OwnerBookingsState {}

class OwnerBookingsLoading extends OwnerBookingsState {}

class OwnerBookingsSuccess extends OwnerBookingsState {
  final List<OwnerBookingModel> bookings;
  OwnerBookingsSuccess(this.bookings);
}

class OwnerBookingsFailure extends OwnerBookingsState {
  final String errMessage;
  OwnerBookingsFailure(this.errMessage);
}
