// import 'package:aqaviatec/core/style/color.dart';
// import 'package:aqaviatec/core/style/styles.dart';
// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({super.key, required this.onTap, required this.text});

//   final VoidCallback onTap;
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: MediaQuery.of(context).size.width < 600 ? 60 : 150,
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: onTap,
//           splashColor: Palette.primary.withValues(alpha: 0.5),
//           highlightColor: Colors.transparent,
//           child: Ink(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Palette.primary, Palette.primary],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             width: double.infinity,
//             height: MediaQuery.of(context).size.width < 600 ? 50 : 55,
//             child: Center(
//               child: Text(
//                 text,
//                 style: Styles.textStyle18Bold.copyWith(
//                   color: Palette.backgroundColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/style/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // 💡 تم جعل onTap قابلة للقيمة الفارغة (final VoidCallback? onTap)
  final VoidCallback? onTap;
  final String text;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    super.key,
    this.onTap, // ⬅️ الآن يمكن تمرير null
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasCustomColor = color != null;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.16,
        //  < 600 ? 60 : 200,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: hasCustomColor
            ? color
            : Colors.transparent, // استخدم اللون المُمرر
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: hasCustomColor
              ? Colors.grey.withValues(alpha: 0.3)
              : Palette.primary,
          highlightColor: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: hasCustomColor ? color : null, // لون ثابت إذا تم تحديده
              gradient: hasCustomColor
                  ? null
                  : const LinearGradient(
                      // تدرج إذا لم يتم تحديد لون
                      colors: [
                        Palette.primary,
                        Palette.primary,
                      ], // Palette.primary أغمق قليلاً
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.width < 600 ? 50 : 55,
            child: Center(
              child: Text(
                text,
                style: (Styles.textStyle18Bold).copyWith(
                  color:
                      textColor ??
                      Palette
                          .backgroundColor, // استخدام لون النص المُمرر أو لون الخلفية
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
