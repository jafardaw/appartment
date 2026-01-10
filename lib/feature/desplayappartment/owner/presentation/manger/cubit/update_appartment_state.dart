abstract class UpdateApartmentState {}

class UpdateApartmentInitial extends UpdateApartmentState {}

class UpdateApartmentLoading extends UpdateApartmentState {}

class UpdateApartmentSuccess extends UpdateApartmentState {
  final String message;
  UpdateApartmentSuccess(this.message);
}

class UpdateApartmentFailure extends UpdateApartmentState {
  final String error;
  UpdateApartmentFailure(this.error);
}
