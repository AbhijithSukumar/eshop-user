import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/routes.dart';
import '../config/configuration.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final useremail = user?.email;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "O R D E R S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("buyer email", isEqualTo: useremail)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final ordersData = snapshot.data!.docs;
            if (ordersData.isEmpty) {
              return  Center(
                  child: Text(
                      'You have not ordered anything to appear on orders',
                      style: Theme.of(context).textTheme.titleLarge,));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ordersData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final order =
                          ordersData[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MyConstants.screenHeight(context) * 0.01),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.odrvw,
                                  arguments: order["id"]);
                            },
                          
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(order["image"]),
                            ),
                            title: Text(order["product name"]),
                            subtitle: order["order delivered"]
                                ? const Text("Order delivered")
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
