import 'package:appartment/core/style/color.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static const textStyle18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Palette.backgroundColor,
  );
  static const textStyle18Bold = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const textStyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Palette.backgroundColor,
    // fontFamily: kGTSectraFineRegular,
  );
  static const textStyle22 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    // fontFamily: kGTSectraFineRegular,
  );
  static const textStyle28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Palette.primary,
  );

  static const textStyle14 = TextStyle(
    color: Palette.text,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Palette.backgroundColor,
  );
  static const textStyle17 = TextStyle(
    fontSize: 17,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );
}
