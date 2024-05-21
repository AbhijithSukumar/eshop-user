import 'package:flutter/material.dart';
import 'package:eshop_user/config/configuration.dart';




class Reusabletextfield extends StatelessWidget {
  final dynamic controller;
  final bool isobscure;
  final dynamic inputtype;
  final String hint;
  const Reusabletextfield({super.key,required this.controller,required this.isobscure,required this.inputtype, required this.hint});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.symmetric(vertical: MyConstants.screenHeight(context)*0.01),
            child: Container(
              height: MyConstants.screenHeight(context)*0.07,
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(MyConstants.screenHeight(context)*0.014),
                color: Theme.of(context).colorScheme.secondary,
              ) ,
              child: Padding(
                padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
                child: TextField(
                  obscureText: isobscure,
                  keyboardType: inputtype,
                  controller: controller,
                  decoration:  InputDecoration(
                    hintText: hint,
                     border: InputBorder.none,
               errorBorder: InputBorder.none,
               disabledBorder: InputBorder.none,
               enabledBorder: InputBorder.none,
               focusedBorder: InputBorder.none,
               focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          );
  }
}