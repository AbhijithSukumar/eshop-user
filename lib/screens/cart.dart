import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/widgets/button.dart';

import '../config/routes.dart';

// import 'package:shop_ease/config/routes.dart';
// import 'package:shop_ease/screens/profile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  @override
  Widget build(BuildContext context) {
    final cartproviders = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "C A R T",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("products")
              .orderBy("price", descending: false)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No  data found.'));
            }

            final userData = snapshot.data!.docs;

            return Consumer<CartProvider>(
              builder: (BuildContext context, value, Widget? child) {
                value.fetchCartProducts();
                double totalPrice = 0.0;
                for (final userDoc in userData) {
                  final userMap = userDoc.data() as Map<String, dynamic>;
                  final price = userMap["price"] ?? 0.0;
                  if (cartproviders._cartList.contains(userMap["productid"])) {
                    totalPrice += price;
                  }
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: userData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final userDoc = userData[index];
                          final Map<String, dynamic> userMap =
                              userDoc.data() as Map<String, dynamic>;
                          final String image = userMap["imageUrls"]?[0] ?? '';
                          final String name = userMap["productName"] ?? '';
                          final double price = userMap["price"] ?? '';

                          if (value._cartList.contains(userMap["productid"])) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(image,
                                          fit: BoxFit.contain)),
                                  title: Text(
                                    name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    "₹ $price",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      value.updatecart(
                                          FirebaseAuth
                                              .instance.currentUser!.email,
                                          userMap["productid"]);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox(width: 0.0, height: 0.0);
                          }
                        },
                      ),
                    ),
                    cartproviders._cartList.isEmpty
                        ? Center(child: Text("cart is empty"))
                        : Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${cartproviders._cartList.length} items"),
                                    Text("${totalPrice}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Delivery charge"),
                                    Text("free")
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${cartproviders._cartList.length} items"),
                                    Text("${totalPrice}")
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomLoginButton(
                                      text: "Buy now",
                                      onPress: () {
                                        Navigator.pushNamed(
                                            context, Routes.odrsumm,
                                            arguments: cartproviders._cartList);
                                      }),
                                )
                              ],
                            ),
                          )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<dynamic> _cartList = [];
  List<dynamic> get cartList => _cartList;

  void fetchCartProducts() async {
    QuerySnapshot cartData = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    var doc = cartData.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    _cartList = userData["cart"];
    notifyListeners();
  }

  void updatecart(String? userEmail, String productId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    List<dynamic> cart = userData["cart"];

    cart.remove(productId);

    await doc.reference.update({"cart": cart});

    notifyListeners();
  }
}
