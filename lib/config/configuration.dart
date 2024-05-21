
import 'package:flutter/material.dart';
ThemeData lightmode=ThemeData(
  colorScheme: ColorScheme.light(
    background:Colors.white,
     primary:Colors.green,
      secondary:Colors.grey.shade400,
       inversePrimary:Colors.green.shade900,
       tertiaryContainer: Colors.green.shade200
  ));
class MyConstants {
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
