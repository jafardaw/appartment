// add_apartment_state.dart

abstract class AddApartmentState {}

class AddApartmentInitial extends AddApartmentState {}

class AddApartmentLoading extends AddApartmentState {}

class AddApartmentSuccess extends AddApartmentState {
  // يمكنك إضافة رسالة نجاح إذا كان السيرفر يعيد واحدة
  final String? message;
  AddApartmentSuccess({this.message});
}

class AddApartmentFailure extends AddApartmentState {
  final String error;
  AddApartmentFailure(this.error);
}
