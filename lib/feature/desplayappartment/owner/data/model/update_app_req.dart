class UpdateApartmentRequest {
  final String method = "PUT"; // ثابتة لأننا في موديل التحديث
  final String title;
  final String description;
  final int rooms;
  final int bathrooms;
  final double pricePerDay;
  final int cityId;
  final String address;

  UpdateApartmentRequest({
    required this.title,
    required this.description,
    required this.rooms,
    required this.bathrooms,
    required this.pricePerDay,
    required this.cityId,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    "_method": method,
    "title": title,
    "description": description,
    "rooms": rooms,
    "bathrooms": bathrooms,
    "price_per_day": pricePerDay,
    "city_id": cityId,
    "address": address,
  };
}
