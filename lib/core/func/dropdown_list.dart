import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? iconColor;
  final Color? fillColor;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.iconColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      iconEnabledColor: iconColor ?? Colors.blue,
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        labelStyle: TextStyle(color: iconColor ?? Colors.blue),
        // focusedBorder: const UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        // ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.black87)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}


////
///CustomDropdownField(
                //   value: _paymentStatus,
                //   label: 'حالة الدفع',
                //   items: ['unpaid', 'paid', 'refunded'],
                //   onChanged: (newValue) =>
                //       setState(() => _paymentStatus = newValue),
                //   iconColor: Palette.primary,
                // ),