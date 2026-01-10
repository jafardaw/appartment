class AddApartmentRequest {
  final String title;
  final String description;
  final int rooms;
  final int bathrooms;
  final double pricePerDay;
  final int cityId;
  final String address;

  AddApartmentRequest({
    required this.title,
    required this.description,
    required this.rooms,
    required this.bathrooms,
    required this.pricePerDay,
    required this.cityId,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "rooms": rooms,
    "bathrooms": bathrooms,
    "price_per_day": pricePerDay,
    "city_id": cityId,
    "address": address,
  };
}
