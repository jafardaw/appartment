// my_bookings_view.dart
import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/core/widget/app_bar_widget.dart';
import 'package:appartment/core/widget/background_viwe.dart';
import 'package:appartment/core/widget/loading_view.dart';
import 'package:appartment/feature/myBooking/data/model/my_booking_model.dart';
import 'package:appartment/feature/myBooking/presentation/manger/cubit/my_bookings_cubit.dart';
import 'package:appartment/feature/myBooking/repo/my_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../manger/cubit/my_bookings_state.dart';

class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyBookingsCubit(BookingRepo(ApiService()))..fetchBookings(),
      child: Scaffold(
        appBar: const AppareWidget(
          title: 'حجوزاتي المتاحة',
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return Center(child: const LoadingViewWidget());
            }

            if (state is MyBookingsFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              );
            }

            if (state is MyBookingsSuccess) {
              final bookings = state.responseModel.bookings;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) =>
                    _buildBookingItem(context, bookings[index]),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, BookingModel booking) {
    return Card(
      elevation: 6, // قلّلت الإرتفاع ليصبح أكثر أناقة
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الحجز + الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.apartment.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                _statusWidget(booking.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "الموقع: ${booking.apartment.address}",
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.grey),
            ),
            const Divider(),

            // التاريخ والسعر
            Row(
              children: [
                const Icon(Icons.date_range, size: 18, color: Colors.blue),
                const SizedBox(width: 5),
                Text(
                  "${booking.startDate} / ${booking.endDate}",
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                Text(
                  "${booking.totalPrice} ل.س",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✨ أزرار تعديل وحذف
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton(
                  context,
                  icon: Icons.edit,
                  label: 'تعديل',
                  color: Colors.blue,
                  onTap: () {
                    // هنا ضع وظيفة التعديل
                    print("تعديل ${booking.apartment.title}");
                  },
                ),
                const SizedBox(width: 10),
                _actionButton(
                  context,
                  icon: Icons.delete,
                  label: 'حذف',
                  color: Colors.red,
                  onTap: () {
                    // هنا ضع وظيفة الحذف
                    print("حذف ${booking.apartment.title}");
                  },
                ),
                _actionButton(
                  context,
                  icon: Icons.star_rate_rounded,
                  label: 'تقييم',
                  color: Colors.amber.shade700,
                  onTap: () => _showRatingDialog(context, booking.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 200.ms, curve: Curves.easeInOut),
    );
  }

  Widget _statusWidget(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'pending'
            ? Colors.orange.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status == 'pending' ? 'قيد الانتظار' : 'مقبول',
        style: TextStyle(
          color: status == 'pending' ? Colors.orange : Colors.green,
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, int bookingId) {
    double selectedRating = 3.0; // القيمة الافتراضية

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "تقييم الإقامة",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "كيف كانت تجربتك في هذه الشقة؟",
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => selectedRating = rating,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "إلغاء",
              style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              try {
                await context.read<MyBookingsCubit>().addReview(
                  bookingId,
                  selectedRating,
                );
                Navigator.pop(context); // إغلاق الديالوج
                showCustomSnackBar(context, "تم التقييم بنجاح، شكراً لك!");
              } catch (e) {
                showCustomSnackBar(
                  context,
                  "لا يمكن التقييم الا بعد  انتهاء مدة  الحجز",
                );
              }
            },
            child: const Text(
              "إرسال",
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
