import 'package:flutter/material.dart';

class ColorPallette {
  ColorPallette._privateConstructor();

  static ColorPallette instance = ColorPallette._privateConstructor();
  factory ColorPallette() {
    return instance;
  }

  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color greyColor = Colors.grey;
  static Color lightGreyColor = Colors.grey.shade300;
  static Color darkGreyColor = Colors.grey.shade700;
  static Color greenColor = Colors.green;
  static Color redColor = const Color.fromARGB(255, 216, 83, 73);
  static Color scaffoldBgColor = Colors.grey.shade300;
}
