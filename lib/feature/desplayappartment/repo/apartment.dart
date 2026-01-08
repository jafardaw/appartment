import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';

class HomeRepo {
  final ApiService apiService;
  HomeRepo(this.apiService);

  Future<List<ApartmentModel>> fetchApartments() async {
    final response = await apiService.get('apartments');
    List<dynamic> data = response.data;
    return data.map((item) => ApartmentModel.fromJson(item)).toList();
  }

  Future<void> bookApartment({
    required int apartmentId,
    required String startDate,
    required String endDate,
  }) async {
    await apiService.post('bookings', {
      'apartment_id': apartmentId,
      'start_date': startDate,
      'end_date': endDate,
    });
  }
}
