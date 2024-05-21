import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';





class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, (FirebaseAuth.instance.currentUser!=null) ?  Routes.roothome: Routes.login,);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
    body: Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        LottieBuilder.asset("assets/Animation - 1708494702546.json"),
         Text("shop ease",style: GoogleFonts.aboreto(
          textStyle: TextStyle(
            fontSize:MyConstants.screenHeight(context)*0.046,
            fontWeight: FontWeight.bold,
          )
         ),)
      ],
    )
    );
  }
}