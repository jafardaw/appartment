import 'package:appartment/core/style/color.dart';
import 'package:appartment/core/style/styles.dart';

import 'package:flutter/material.dart';

class AppareWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppareWidget({
    super.key,
    required this.title,
    required this.automaticallyImplyLeading,
    this.leading,
    this.actions,
  });

  final String title;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        if (actions != null) ...actions!,
        SizedBox(width: 10),
        // Image.asset(
        //   height: 40,
        //   width: 40,
        //   Assets.assetsImagesLogo2RemovebgPreview,
        //   color: Colors.white,
        // ) // الشعار دايمًا موجود
        // إضافة الأيقونات الإضافية إذا موجودة
      ],
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Palette.primary,
      title: Center(
        child: Text(
          title,
          style: Styles.textStyle18.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
