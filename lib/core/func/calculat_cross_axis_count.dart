import 'package:flutter/material.dart';

int calculateCrossAxisCount(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width > 1200) {
    return 4;
  } else if (width > 850) {
    return 3;
  } else if (width > 550) {
    return 2;
  } else {
    return 1;
  }
}

int calculateCrossAxisCountuser(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > 1200) {
    return 7;
  } else if (width > 850) {
    return 5;
  } else if (width > 550) {
    return 3;
  } else {
    return 2;
  }
}
