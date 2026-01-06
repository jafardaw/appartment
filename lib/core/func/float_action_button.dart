import 'package:appartment/core/style/color.dart';
import 'package:flutter/material.dart';

FloatingActionButton buildFloatactionBoutton(
  BuildContext context, {
  required Function() onPressed,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: Palette.primary,
    child: const Icon(Icons.add, color: Colors.white),
  );
}
