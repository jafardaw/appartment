import 'package:appartment/feature/desplayappartment/owner/data/model/update_app_req.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/update_appartment_state.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateApartmentCubit extends Cubit<UpdateApartmentState> {
  final HomeRepo updateRepo;
  UpdateApartmentCubit(this.updateRepo) : super(UpdateApartmentInitial());

  Future<void> updateApartment(int id, UpdateApartmentRequest request) async {
    emit(UpdateApartmentLoading());
    try {
      await updateRepo.updateApartment(id, request);
      emit(UpdateApartmentSuccess("تم تحديث بيانات العقار بنجاح"));
    } catch (e) {
      emit(UpdateApartmentFailure("حدث خطأ أثناء التحديث، حاول لاحقاً"));
    }
  }
}
