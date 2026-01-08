// Apartment Model
class ApartmentModel {
  final int id;
  final String title;
  final String description;
  final String address;
  final String pricePerDay;
  final int rooms;
  final int bathrooms;
  final CityModel city;
  final OwnerModel owner;

  ApartmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.pricePerDay,
    required this.rooms,
    required this.bathrooms,
    required this.city,
    required this.owner,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      pricePerDay: json['price_per_day'].toString(),
      rooms: json['rooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      city: CityModel.fromJson(json['city']),
      owner: OwnerModel.fromJson(json['owner']),
    );
  }
}

// City Model
class CityModel {
  final int id;
  final String name;
  final GovernorateModel? governorate;

  CityModel({required this.id, required this.name, this.governorate});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      governorate: json['governorate'] != null
          ? GovernorateModel.fromJson(json['governorate'])
          : null,
    );
  }
}

// Governorate Model
class GovernorateModel {
  final int id;
  final String name;

  GovernorateModel({required this.id, required this.name});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(id: json['id'], name: json['name']);
  }
}

// Owner Model
class OwnerModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? profileImage;

  OwnerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profileImage,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}
