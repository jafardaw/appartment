import 'package:appartment/core/style/color.dart';
import 'package:flutter/material.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  List<Widget>? actions,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Alert",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, __) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return ScaleTransition(
        scale: curved,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.blue, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, size: 28, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Palette.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions:
              actions ??
              [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      shadowColor: Colors.blue.shade200,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'رجوع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
        ),
      );
    },
  );
}
