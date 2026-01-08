// booking_model.dart
class BookingResponseModel {
  final List<BookingModel> bookings;

  BookingResponseModel({required this.bookings});

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      bookings: (json['bookings'] as List)
          .map((i) => BookingModel.fromJson(i))
          .toList(),
    );
  }
}

class BookingModel {
  final int id;
  final String startDate;
  final String endDate;
  final String totalPrice;
  final String status;
  final ApartmentInsideBooking apartment;

  BookingModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.apartment,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalPrice: json['total_price'],
      status: json['status'],
      apartment: ApartmentInsideBooking.fromJson(json['apartment']),
    );
  }
}

class ApartmentInsideBooking {
  final String title;
  final String address;
  final String pricePerDay;

  ApartmentInsideBooking({
    required this.title,
    required this.address,
    required this.pricePerDay,
  });

  factory ApartmentInsideBooking.fromJson(Map<String, dynamic> json) {
    return ApartmentInsideBooking(
      title: json['title'],
      address: json['address'],
      pricePerDay: json['price_per_day'],
    );
  }
}
