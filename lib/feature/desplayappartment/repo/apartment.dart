import 'package:appartment/core/error/eror_handel.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:appartment/feature/desplayappartment/owner/data/add_appart_request.dart';
import 'package:appartment/feature/desplayappartment/owner/data/model/update_app_req.dart';
import 'package:dio/dio.dart';

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

  Future<void> addApartment(AddApartmentRequest request) async {
    try {
      await apiService.post('apartments', request.toJson());
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateApartment(int id, UpdateApartmentRequest request) async {
    await apiService.post("apartments/$id", request.toJson());
  }
}
