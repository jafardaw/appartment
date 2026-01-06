import 'package:appartment/core/func/show_snak_bar.dart';
import 'package:appartment/core/style/color.dart';
import 'package:flutter/material.dart';

class ShowErrorWidgetView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final bool showImage;

  const ShowErrorWidgetView({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.showRetryButton = true,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showImage) ...[
              Icon(Icons.error_outline, size: 64, color: Palette.error),
              const SizedBox(height: 20),
            ],

            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (showRetryButton && onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text('إعادة المحاولة'),
              ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لعرض الخطأ كـ SnackBar
  static void showErrorSnackBar(BuildContext context, String errorMessage) {
    showCustomSnackBar(context, errorMessage, color: Palette.error);
  }

  // دالة مساعدة لعرض الخطأ في صفحة كاملة
  static Widget fullScreenError({
    required String errorMessage,
    VoidCallback? onRetry,
    bool showImage = true,
  }) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor, // استخدام لون الخلفية الجديد

      body: ShowErrorWidgetView(
        errorMessage: errorMessage,
        onRetry: onRetry,
        showImage: showImage,
      ),
    );
  }

  // دالة مساعدة لعرض الخطأ في جزء من الصفحة
  static Widget inlineError({
    required String errorMessage,
    VoidCallback? onRetry,
    bool showImage = false,
  }) {
    return ShowErrorWidgetView(
      errorMessage: errorMessage,
      onRetry: onRetry,
      showImage: showImage,
      showRetryButton: onRetry != null,
    );
  }
}
