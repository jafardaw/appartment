import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/widget/app_bar_widget.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/custom_field.dart';
import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:appartment/feature/desplayappartment/owner/data/model/update_app_req.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/update_appartment_cubit.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/update_appartment_state.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/apartments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateApartmentView extends StatefulWidget {
  final ApartmentModel apartment;
  const UpdateApartmentView({super.key, required this.apartment});

  @override
  State<UpdateApartmentView> createState() => _UpdateApartmentViewState();
}

class _UpdateApartmentViewState extends State<UpdateApartmentView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers محملة ببيانات الشقة الحالية
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController roomsController;
  late TextEditingController bathController;
  late TextEditingController priceController;
  late TextEditingController addressController;
  int? selectedCityId;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.apartment.title);
    descController = TextEditingController(text: widget.apartment.description);
    roomsController = TextEditingController(
      text: widget.apartment.rooms.toString(),
    );
    bathController = TextEditingController(
      text: widget.apartment.bathrooms.toString(),
    );
    priceController = TextEditingController(
      text: widget.apartment.pricePerDay.toString(),
    );
    addressController = TextEditingController(text: widget.apartment.address);
    selectedCityId = widget.apartment.city.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'تعديل بيانات الشقة',
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<UpdateApartmentCubit, UpdateApartmentState>(
        listener: (context, state) {
          if (state is UpdateApartmentSuccess) {
            showCustomSnackBar(context, state.message, color: Palette.success);
            // تحديث قائمة الشقق في الصفحة السابقة
            context.read<ApartmentsCubit>().getApartments();
            Navigator.pop(context); // العودة التلقائية
          }
          if (state is UpdateApartmentFailure) {
            showCustomSnackBar(context, state.error, color: Palette.success);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: titleController,
                        hintText: 'عنوان الشقة',
                        prefixIcon: Icon(Icons.title),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: descController,
                        hintText: 'الوصف',
                        prefixIcon: Icon(Icons.description),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: roomsController,
                              hintText: 'الغرف',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icon(Icons.bed),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              controller: bathController,
                              hintText: 'الحمامات',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icon(Icons.bathtub),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: priceController,
                        hintText: 'السعر باليوم',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: addressController,
                        hintText: 'العنوان بالتفصيل',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: 'حفظ التعديلات',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final request = UpdateApartmentRequest(
                              title: titleController.text,
                              description: descController.text,
                              rooms: int.parse(roomsController.text),
                              bathrooms: int.parse(bathController.text),
                              pricePerDay: double.parse(priceController.text),
                              cityId: selectedCityId ?? 1,
                              address: addressController.text,
                            );
                            context
                                .read<UpdateApartmentCubit>()
                                .updateApartment(widget.apartment.id, request);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
