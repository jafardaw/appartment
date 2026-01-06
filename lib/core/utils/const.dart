import 'package:appartment/core/style/color.dart';
import 'package:flutter/material.dart';

const double maxWidth = 600.0;
const double maxWidthRegster = 1000.0;
// const double maxWidthVideo = 200.0;
Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'new':
      return Colors.green.shade600;
    case 'in_progress':
      return Colors.blue.shade600;
    case 'closed':
      return Colors.grey.shade600;
    case 'high':
      return Palette.error; // لون الخطأ (أحمر)
    default:
      return Colors.amber.shade700;
  }
}

Map<String, dynamic> getStatusDetails(String status) {
  switch (status.toLowerCase()) {
    case 'new':
      return {
        'text': 'جديدة',
        'color': Colors.blue,
        'icon': Icons.fiber_new_outlined,
      };
    case 'in_progress':
      return {
        'text': 'قيد المعالجة',
        'color': Colors.orange,
        'icon': Icons.trending_up,
      };
    case 'resolved':
      return {
        'text': 'تم الحل',
        'color': Colors.green,
        'icon': Icons.check_circle_outline,
      };
    case 'rejected':
      return {
        'text': 'مرفوضة',
        'color': Palette.error,
        'icon': Icons.highlight_off,
      };
    default:
      return {'text': status, 'color': Colors.grey, 'icon': Icons.help_outline};
  }
}
