import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/widget/app_bar_widget.dart';
import 'package:appartment/core/widget/custom_button.dart';
import 'package:appartment/feature/desplayappartment/data/model/apartment_model.dart';
import 'package:appartment/feature/desplayappartment/owner/presentation/manger/cubit/update_appartment_state.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/booking_cubit.dart';
import 'package:appartment/feature/desplayappartment/presentation/manger/cubit/booking_state.dart';
import 'package:appartment/feature/desplayappartment/repo/apartment.dart'; // تأكد من أن HomeRepo معرف هنا
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApartmentDetailsView extends StatefulWidget {
  final ApartmentModel apartment;
  const ApartmentDetailsView({super.key, required this.apartment});

  @override
  State<ApartmentDetailsView> createState() => _ApartmentDetailsViewState();
}

class _ApartmentDetailsViewState extends State<ApartmentDetailsView> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      locale: const Locale('ar', 'AE'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدمنا BlocProvider هنا مع التأكد من وجود HomeRepo في الشجرة
    return Scaffold(
      appBar: AppareWidget(
        title: 'تفاصيل العقار',
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            showCustomSnackBar(context, state.message);
            Navigator.pop(context);
          } else if (state is BookingFailure) {
            showCustomSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عرض صورة افتراضية أو من الـ Model
                Card(
                  elevation: 0,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: const Icon(
                      Icons.home_work_outlined,
                      size: 80,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  widget.apartment.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.apartment.city.name} - ${widget.apartment.address}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // كرت المواصفات (Rounded Corners & Card)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(
                          Icons.bed,
                          "${widget.apartment.rooms} غرف",
                        ),
                        _buildInfoItem(
                          Icons.bathtub,
                          "${widget.apartment.bathrooms} حمام",
                        ),
                        _buildInfoItem(
                          Icons.monetization_on,
                          "${widget.apartment.pricePerDay} ل.س",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                const Text(
                  'وصف العقار',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.apartment.description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                ),

                const Divider(height: 40),

                // قسم اختيار التاريخ
                const Text(
                  'تحديد موعد الحجز',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          startDate == null
                              ? "اضغط لتحديد تاريخ البداية والنهاية"
                              : "${startDate!.toString().split(' ')[0]}  إلى  ${endDate!.toString().split(' ')[0]}",
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // زر الحجز المخصص (CustomButton) مع حالة التحميل
                state is BookingLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'تأكيد الحجز الآن',
                        onTap: () {
                          if (startDate != null && endDate != null) {
                            context.read<BookingCubit>().createBooking(
                              widget.apartment.id,
                              startDate!.toString().split(' ')[0],
                              endDate!.toString().split(' ')[0],
                            );
                          } else {
                            showCustomSnackBar(
                              context,
                              "الرجاء تحديد المدة أولاً",
                            );
                          }
                        },
                      ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
      ],
    );
  }
}
