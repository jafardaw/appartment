import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/utils/api_service.dart';
import 'package:appartment/core/widget/app_bar_widget.dart';
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
              return const Center(child: LoadingViewWidget());
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
              if (bookings.isEmpty) {
                return const Center(
                  child: Text(
                    "لا يوجد حجوزات حالياً",
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                );
              }
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // زر التعديل يظهر فقط إذا كان الحجز قيد الانتظار
                if (booking.status == 'pending')
                  _actionButton(
                    context,
                    icon: Icons.edit,
                    label: 'تعديل',
                    color: Colors.blue,
                    onTap: () {
                      DateTime startDate = DateTime.parse(booking.startDate);
                      if (startDate.isBefore(DateTime.now())) {
                        showCustomSnackBar(
                          context,
                          "لا يمكن تعديل حجز بدأ بالفعل",
                          color: Colors.orange,
                        );
                      } else {
                        _editBookingDates(context, booking);
                      }
                    },
                  ),
                const SizedBox(width: 8),
                // زر الحذف
                if (booking.status == 'pending')
                  _actionButton(
                    context,
                    icon: Icons.delete,
                    label: 'حذف',
                    color: Colors.red,
                    onTap: () => _confirmCancelBooking(context, booking),
                  ),
                if (booking.status != 'pending')
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

  // --- وظائف التعديل والحذف ---

  Future<void> _editBookingDates(
    BuildContext context,
    BookingModel booking,
  ) async {
    // 1. تحديد تاريخ اليوم كحد أدنى
    DateTime now = DateTime.now();
    DateTime firstAvailableDate = DateTime(now.year, now.month, now.day);

    // 2. تحويل تواريخ الحجز من نصوص إلى DateTime
    DateTime bookingStart = DateTime.parse(booking.startDate);
    DateTime bookingEnd = DateTime.parse(booking.endDate);

    // 3. معالجة التواريخ لتجنب الـ Assertion Error
    // إذا كان تاريخ الحجز قديم (قبل اليوم)، نجعل الافتراضي يبدأ من اليوم
    DateTime initialStart = bookingStart.isBefore(firstAvailableDate)
        ? firstAvailableDate
        : bookingStart;

    // التأكد من أن تاريخ النهاية بعد تاريخ البداية الجديد
    DateTime initialEnd = bookingEnd.isBefore(initialStart)
        ? initialStart.add(const Duration(days: 1))
        : bookingEnd;

    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      locale: const Locale('ar'),
      firstDate: firstAvailableDate, // لا يمكن اختيار تاريخ قبل اليوم
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
    );

    if (pickedRange != null) {
      final start = pickedRange.start.toString().split(' ')[0];
      final end = pickedRange.end.toString().split(' ')[0];

      await context.read<MyBookingsCubit>().updateBooking(
        booking.id,
        start,
        end,
      );
      if (context.mounted)
        showCustomSnackBar(context, "تم إرسال طلب التعديل بنجاح");
    }
  }

  void _confirmCancelBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "إلغاء الحجز",
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          content: Text(
            "هل أنت متأكد من رغبتك في إلغاء حجزك في ${booking.apartment.title}؟",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "تراجع",
                style: TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await context.read<MyBookingsCubit>().deleteBooking(booking.id);
                if (context.mounted)
                  showCustomSnackBar(context, "تم إلغاء الحجز بنجاح");
              },
              child: const Text(
                "تأكيد الحذف",
                style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- الـ Widgets المساعدة ---

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 150.ms),
    );
  }

  Widget _statusWidget(String status) {
    bool isPending = status == 'pending';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.orange.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isPending ? 'قيد الانتظار' : 'مقبول',
        style: TextStyle(
          color: isPending ? Colors.orange : Colors.green,
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, int bookingId) {
    double selectedRating = 3.0;
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              try {
                await context.read<MyBookingsCubit>().addReview(
                  bookingId,
                  selectedRating,
                );
                Navigator.pop(context);
                showCustomSnackBar(context, "تم التقييم بنجاح، شكراً لك!");
              } catch (e) {
                showCustomSnackBar(
                  context,
                  "لا يمكن التقييم إلا بعد انتهاء مدة الحجز",
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
