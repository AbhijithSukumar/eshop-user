// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppBar(
      title: const Text("S E T T I N G S",
      style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(onPressed:logout, icon: const Icon(Icons.logout))
      ],
    ),
    body: Padding(
      padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.013),
      child:  Column(
        children: [
          Tiles(text: "O R D E R S", icon: Icons.local_shipping, press: (){
              Navigator.pushNamed(context, Routes.order);
         },),
         Tiles(text: "P R O F I L E", icon: Icons.account_circle, press: (){
          Navigator.pushNamed(context, Routes.profile);
         },),
         Tiles(text: "W I S H L I S T", icon: Icons.favorite_rounded, press: (){
          Navigator.pushNamed(context, Routes.wishlist);
         },)
        ],
      ),
    ),
    );
  }
}

class Tiles extends StatelessWidget {
 final dynamic text;
 final dynamic icon;
 final dynamic press;
  const Tiles({super.key,required this.text,required this.icon,required this.press});

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding:  EdgeInsets.symmetric(vertical: MyConstants.screenHeight(context)*0.01),
            child: GestureDetector(
              onTap: press,
              child: Container(
                height: MyConstants.screenHeight(context)*0.07,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(MyConstants.screenHeight(context)*0.025)
                ),
                child:   Padding(
                  padding:  EdgeInsets.symmetric(horizontal: MyConstants.screenHeight(context)*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                          Icon(icon,size: MyConstants.screenHeight(context)*0.04,),
                          SizedBox(
                            width: MyConstants.screenWidth(context)*0.04,
                          ),
                          Text(text,
                           style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MyConstants.screenHeight(context)*0.02,
                        
                        ),)
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}