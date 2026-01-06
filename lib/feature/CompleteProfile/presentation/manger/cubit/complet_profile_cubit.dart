import 'package:appartment/feature/CompleteProfile/presentation/manger/cubit/complet_profile_state.dart';
import 'package:appartment/feature/CompleteProfile/repo/cmplet_profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final ProfileRepo _repo;
  CompleteProfileCubit(this._repo) : super(CompleteProfileInitial());

  Future<void> completeProfile({
    required String fName,
    required String lName,
    required String bDate,
    required XFile idImg,
    required XFile pImg,
  }) async {
    emit(CompleteProfileLoading());
    try {
      final result = await _repo.completeProfile(
        firstName: fName,
        lastName: lName,
        birthDate: bDate,
        idImagePath: idImg,
        profileImagePath: pImg,
      );
      emit(CompleteProfileSuccess(result['message'] ?? "تم تحديث الملف بنجاح"));
    } catch (e) {
      emit(CompleteProfileFailure(e.toString()));
    }
  }
}
