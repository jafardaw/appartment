import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/widget/app_bar_widget.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/core/widget/custom_field.dart';
import 'package:appartment/core/widget/loading_view.dart';
import 'package:appartment/feature/desplayappartment/owner/data/add_appart_request.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/add_apartment_cubit.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/add_apartment_state.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/apartments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddApartmentView extends StatefulWidget {
  const AddApartmentView({super.key});

  @override
  State<AddApartmentView> createState() => _AddApartmentViewState();
}

class _AddApartmentViewState extends State<AddApartmentView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final roomsController = TextEditingController();
  final bathController = TextEditingController();
  final priceController = TextEditingController();
  final addressController = TextEditingController();

  // متغير لتخزين معرف المدينة المختار
  int? selectedCityId;

  // قائمة المدن (يمكنك جلبها لاحقاً من API)
  final List<Map<String, dynamic>> cities = [
    {'id': 1, 'name': 'المزة'},
    {'id': 2, 'name': 'كفرسوسة'},
    {'id': 3, 'name': 'المالكي'},
    {'id': 4, 'name': 'ركن الدين'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppareWidget(
        title: 'إضافة شقة جديدة',
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: BlocConsumer<AddApartmentCubit, AddApartmentState>(
          listener: (context, state) {
            if (state is AddApartmentSuccess) {
              showCustomSnackBar(
                context,
                "تمت إضافة الشقة بنجاح",
                color: Palette.success,
              );
              context.read<ApartmentsCubit>().getApartments();
              Navigator.pop(context);
            }
            if (state is AddApartmentFailure) {
              showCustomSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: titleController,
                      hintText: 'عنوان الشقة',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: descController,
                      hintText: 'وصف الشقة',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: roomsController,
                            hintText: 'الغرف',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            controller: bathController,
                            hintText: 'الحمامات',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: priceController,
                      hintText: 'السعر باليوم',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    // --- Dropdown القائمة المنسدلة للمدن ---
                    DropdownButtonFormField<int>(
                      initialValue: selectedCityId,
                      hint: const Text(
                        'اختر المدينة',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // زوايا 10 كما طلبت
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: cities.map((city) {
                        return DropdownMenuItem<int>(
                          value: city['id'],
                          child: Text(
                            city['name'],
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCityId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'الرجاء اختيار مدينة' : null,
                    ),

                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: addressController,
                      hintText: 'العنوان بالتفصيل',
                    ),
                    const SizedBox(height: 30),

                    state is AddApartmentLoading
                        ? const LoadingViewWidget()
                        : CustomButton(
                            text: 'نشر الشقة الآن',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AddApartmentCubit>().addApartment(
                                  AddApartmentRequest(
                                    title: titleController.text,
                                    description: descController.text,
                                    rooms: int.parse(roomsController.text),
                                    bathrooms: int.parse(bathController.text),
                                    pricePerDay: double.parse(
                                      priceController.text,
                                    ),
                                    cityId:
                                        selectedCityId!, // نرسل الـ ID المختار
                                    address: addressController.text,
                                  ),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
