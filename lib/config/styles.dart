import 'package:flutter/material.dart';

class Styles {
  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.04, 
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.03, 
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }
   static TextStyle subtitlegrey(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.022, 
      letterSpacing: 1,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
    );
  }

  static TextStyle button(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.025, 
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle labelText(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.02, 
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    );
  }
}
