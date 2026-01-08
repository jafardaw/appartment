import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<List<ApartmentModel>> {
  FavoritesCubit() : super([]);

  void toggleFavorite(ApartmentModel apartment) {
    final currentList = List<ApartmentModel>.from(state);
    if (currentList.any((item) => item.id == apartment.id)) {
      currentList.removeWhere((item) => item.id == apartment.id);
    } else {
      currentList.add(apartment);
    }
    emit(currentList);
  }

  bool isFavorite(ApartmentModel apartment) {
    return state.any((item) => item.id == apartment.id);
  }
}
