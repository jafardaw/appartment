import 'package:flutter/material.dart';
// تأكد من استيراد مسار Assets الصحيح

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String backgroundImagePath;
  final bool applyOverlay; // خيار للتحكم في طبقة التعتيم

  const BackgroundWrapper({
    super.key,
    required this.child,
    required this.backgroundImagePath,
    this.applyOverlay = true, // التعتيم مفعّل بشكل افتراضي
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover, // لتغطية الشاشة بالكامل
          ),
        ),

        if (applyOverlay)
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.36)),
          ),

        Scaffold(backgroundColor: Colors.transparent, body: child),
      ],
    );
  }
}
