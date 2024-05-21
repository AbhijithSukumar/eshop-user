import 'package:flutter/material.dart';
import 'package:eshop_user/config/styles.dart';




class CustomLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const CustomLoginButton({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme; 

    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      width: MediaQuery.of(context)
          .size
          .width,
      decoration: BoxDecoration(
        color: colorScheme.primary, 
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.height * 0.01,
        ),
      ),
      child: TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: Styles.button(
              context), 
        ),
      ),
    );
  }
}
