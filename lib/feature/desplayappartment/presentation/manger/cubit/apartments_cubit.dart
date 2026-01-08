import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/apartments_state.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApartmentsCubit extends Cubit<ApartmentsState> {
  final HomeRepo _repo;

  // مخزن البيانات الأصلي (لا يتأثر بالفلترة)
  List<ApartmentModel> _allApartments = [];

  ApartmentsCubit(this._repo) : super(ApartmentsInitial());

  Future<void> getApartments() async {
    emit(ApartmentsLoading());
    try {
      final apartments = await _repo.fetchApartments();
      _allApartments = apartments; // تخزين النسخة الأصلية
      emit(ApartmentsSuccess(apartments));
    } catch (e) {
      emit(ApartmentsFailure(e.toString()));
    }
  }

  // ميثود الفلترة المحلية (سعر ومدينة)
  void filterApartments({String? cityName, double? maxPrice}) {
    List<ApartmentModel> filtered = _allApartments.where((apartment) {
      // منطق فلترة المدينة
      bool matchCity = true;
      if (cityName != null && cityName.isNotEmpty) {
        matchCity = apartment.city.name.toLowerCase().contains(
          cityName.toLowerCase(),
        );
      }

      // منطق فلترة السعر
      bool matchPrice = true;
      if (maxPrice != null) {
        double price = double.tryParse(apartment.pricePerDay) ?? 0;
        matchPrice = price <= maxPrice;
      }

      return matchCity && matchPrice;
    }).toList();

    emit(ApartmentsSuccess(filtered));
  }

  // إعادة ضبط الفلاتر
  void clearFilter() {
    emit(ApartmentsSuccess(_allApartments));
  }
}
