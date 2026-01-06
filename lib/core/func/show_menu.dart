import 'package:flutter/material.dart';

void showProductMenu({
  required BuildContext context,
  required Offset position,
  required List<Map<String, dynamic>> menuItems,
}) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      position & const Size(40, 40),
      Offset.zero & overlay.size,
    ),
    items: menuItems.map((item) {
      return PopupMenuItem(
        value: item['value'],
        child: ListTile(
          leading: item['icon'] as Widget,
          title: Text(item['title'] as String),
          onTap: () {
            Navigator.pop(context); // إغلاق القائمة بعد النقر
            item['onTap'](); // تنفيذ الدالة المخصصة
          },
        ),
      );
    }).toList(),
    elevation: 8.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
}
