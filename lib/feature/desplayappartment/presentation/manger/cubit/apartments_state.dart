import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';

abstract class ApartmentsState {}

class ApartmentsInitial extends ApartmentsState {}

class ApartmentsLoading extends ApartmentsState {}

class ApartmentsSuccess extends ApartmentsState {
  final List<ApartmentModel> apartments;

  ApartmentsSuccess(this.apartments);
}

class ApartmentsFailure extends ApartmentsState {
  final String error;

  ApartmentsFailure(this.error);
}
