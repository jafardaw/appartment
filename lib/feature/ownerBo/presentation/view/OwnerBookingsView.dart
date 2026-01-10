import 'package:appartment/core/func/show_snak_bar.dart'; // استيراد السناك بار الخاص بك
import 'package:appartment/core/style/color.dart';
import 'package:appartment/feature/ownerBo/data/model/owner_boking_model.dart';
import 'package:appartment/feature/ownerBo/presentation/manger/cubit/owner_booking_cubit.dart';
import 'package:appartment/feature/ownerBo/presentation/manger/cubit/owner_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerBookingsView extends StatefulWidget {
  const OwnerBookingsView({super.key});

  @override
  State<OwnerBookingsView> createState() => _OwnerBookingsViewState();
}

class _OwnerBookingsViewState extends State<OwnerBookingsView> {
  @override
  void initState() {
    context.read<OwnerBookingsCubit>().fetchOwnerBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حجوزات شققي',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<OwnerBookingsCubit, OwnerBookingsState>(
        builder: (context, state) {
          if (state is OwnerBookingsSuccess) {
            if (state.bookings.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد حجوزات حالياً",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) =>
                  _buildBookingCard(context, state.bookings[index]),
            );
          } else if (state is OwnerBookingsFailure) {
            return Center(child: Text(state.errMessage));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, OwnerBookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.apartment.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
                _buildStatusBadge(booking.status),
              ],
            ),
            const Divider(height: 20),
            _buildInfoRow(
              Icons.location_on,
              "${booking.apartment.governorate} - ${booking.apartment.city}",
            ),
            _buildInfoRow(Icons.phone, "رقم المستأجر: ${booking.tenant.phone}"),
            _buildInfoRow(
              Icons.date_range,
              "من: ${booking.startDate}  إلى: ${booking.endDate}",
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "إجمالي السعر:",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${booking.totalPrice} ل.س",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                // --- التعديل هنا: إضافة الأزرار في حال كان الطلب "Pending" ---
                if (booking.status == "pending")
                  Row(
                    children: [
                      _buildActionBtn(
                        icon: Icons.check_circle,
                        color: Colors.green,
                        onPressed: () =>
                            _updateStatus(context, booking.bookingId, true),
                      ),
                      const SizedBox(width: 12),
                      _buildActionBtn(
                        icon: Icons.cancel,
                        color: Colors.red,
                        onPressed: () =>
                            _updateStatus(context, booking.bookingId, false),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ميثود مساعدة لبناء زر القبول والرفض بشكل أنيق
  Widget _buildActionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }

  // ميثود لتنفيذ الطلب وإظهار النتيجة
  void _updateStatus(BuildContext context, int id, bool isApprove) async {
    await context.read<OwnerBookingsCubit>().updateBookingStatus(id, isApprove);

    if (mounted) {
      showCustomSnackBar(
        context,
        isApprove ? "تم قبول الحجز بنجاح" : "تم رفض طلب الحجز",
        color: isApprove ? Palette.success : Colors.red,
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    // منطق بسيط لعرض الحالات المختلفة
    Color color;
    String text;
    if (status == "pending") {
      color = Colors.orange;
      text = "قيد الانتظار";
    } else if (status == "approved") {
      color = Colors.green;
      text = "مقبول";
    } else {
      color = Colors.red;
      text = "مرفوض";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
