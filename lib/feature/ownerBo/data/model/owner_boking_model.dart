class OwnerBookingModel {
  final int bookingId;
  final String status;
  final TenantModel tenant;
  final BookingApartmentModel apartment;
  final String startDate;
  final String endDate;
  final String totalPrice;

  OwnerBookingModel({
    required this.bookingId,
    required this.status,
    required this.tenant,
    required this.apartment,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
  });

  factory OwnerBookingModel.fromJson(Map<String, dynamic> json) {
    return OwnerBookingModel(
      bookingId: json['booking_id'],
      status: json['status'],
      tenant: TenantModel.fromJson(json['tenant']),
      apartment: BookingApartmentModel.fromJson(json['apartment']),
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalPrice: json['total_price'],
    );
  }
}

class TenantModel {
  final int id;
  final String phone;

  TenantModel({required this.id, required this.phone});

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(id: json['id'], phone: json['phone']);
  }
}

class BookingApartmentModel {
  final String title;
  final String city;
  final String governorate;

  BookingApartmentModel({required this.title, required this.city, required this.governorate});

  factory BookingApartmentModel.fromJson(Map<String, dynamic> json) {
    return BookingApartmentModel(
      title: json['title'],
      city: json['city'],
      governorate: json['governorate'],
    );
  }
}