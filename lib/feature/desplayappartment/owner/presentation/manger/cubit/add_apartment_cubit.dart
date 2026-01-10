import 'package:appartment/feature/desplayappartment/owner/data/add_appart_request.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/add_apartment_state.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddApartmentCubit extends Cubit<AddApartmentState> {
  final HomeRepo _repo;
  AddApartmentCubit(this._repo) : super(AddApartmentInitial());

  Future<void> addApartment(AddApartmentRequest request) async {
    emit(AddApartmentLoading());
    try {
      await _repo.addApartment(request);
      emit(AddApartmentSuccess());
    } catch (e) {
      emit(AddApartmentFailure(e.toString()));
    }
  }
}
