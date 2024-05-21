import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:eshop_user/config/routes.dart';

class OrderConfirmed extends StatefulWidget {
  const OrderConfirmed({super.key});

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
   @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context,Routes.roothome);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Theme.of(context).colorScheme.background,
body: Center(
  child: LottieBuilder.asset("assets/Animation - 1709369592922.json"),
),
    );
  }
}