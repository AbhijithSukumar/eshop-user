


// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:eshop_user/screens/cart.dart';
import 'package:eshop_user/screens/category.dart';
import 'package:eshop_user/screens/homescreen.dart';
import 'package:eshop_user/screens/notifications.dart';
import 'package:eshop_user/screens/order.dart';
import 'package:eshop_user/screens/profile.dart';
import 'package:eshop_user/screens/settings.dart';
import 'package:eshop_user/screens/wishlist.dart';


class Rootpage extends StatefulWidget {
  const Rootpage({super.key}) ;

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 3),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade300,
        selectedItemColor: Colors.green.shade900,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: "favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: "orders"),
        ],
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
        Home(),
    Wishlist(),
    ProfileScreen(),
    CartPage(),
    OrderScreen()
        ],
      ),
    );
  }
}
