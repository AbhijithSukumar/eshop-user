// ignore_for_file: avoid_print

import 'package:eshop_user/screens/ratings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/firebase_options.dart';
import 'package:eshop_user/screens/card.dart';
import 'package:eshop_user/screens/cart.dart';
import 'package:eshop_user/screens/categoryview.dart';
import 'package:eshop_user/screens/editprofile.dart';
import 'package:eshop_user/screens/forgotpassword.dart';
import 'package:eshop_user/screens/homescreen.dart';
import 'package:eshop_user/screens/login.dart';
import 'package:eshop_user/screens/oderview.dart';
import 'package:eshop_user/screens/order.dart';
import 'package:eshop_user/screens/orderconfirmed.dart';
import 'package:eshop_user/screens/ordersummary.dart';
import 'package:eshop_user/screens/payments.dart';
import 'package:eshop_user/screens/profile.dart';
import 'package:eshop_user/screens/register.dart';
import 'package:eshop_user/screens/root.dart';
import 'package:eshop_user/screens/splash.dart';
import 'package:eshop_user/screens/viewproduct.dart';
import 'package:eshop_user/screens/wishlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => WhishListProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PaymentMethodProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      initialRoute: Routes.splash,
      routes: {
        Routes.roothome: (context) => const Rootpage(),
        Routes.login: (context) => const LoginScreen(),
        Routes.splash: (context) => const SplashScreen(),
        Routes.forgot: (context) => const ForgotPassword(),
        Routes.profile: (context) => const ProfileScreen(),
        Routes.order: (context) => const OrderScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.editprofile: (context) => const EditProfileScreen(),
        Routes.viewproduct: (context) => const ViewProduct(),
        Routes.viewcategory: (context) => const CategoryView(),
        Routes.wishlist: (context) => const Wishlist(),
        Routes.confirm: (context) => const OrderConfirmed(),
        Routes.odrvw: (context) => const OrderView(),
        Routes.odrsumm: (context) => const OrderSummary(),
        Routes.payment: (context) => const PaymentScreen(),
      Routes.card: (context) => const CardData(),
      Routes.ratings:(context) => const Ratings()
      },

    );
  }
}
