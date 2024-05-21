// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/widgets/button.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as List;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "O R D E R   S U M M A R Y",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("email",
                    isEqualTo: FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              final userData = snapshot.data!.docs;
              final userDoc = userData.first;
              final documentId = userDoc.id;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Align(
                    alignment: Alignment.centerLeft,
                    child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Error: ${snapshot.error}'));
              }
              if (userData.isEmpty) {
                return const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('No user data found.'));
              }

              final userMap = userData.first.data() as Map<String, dynamic>;
              final phone = userMap['phone'] ?? '';
              final address = userMap['Steetadress'] ?? '';
              final name = userMap['username'] ?? '';
              final pincode = userMap['pincode'] ?? '';
              final state = userMap['state'] ?? '';
              final district = userMap['district'] ?? '';
              final house = userMap['housename'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Name: $name")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Phone: $phone")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("House Name: $house")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Street Address: $address")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("District: $district")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("State: $state")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Pincode: $pincode")),
                ]),
              );
            },
          ),
          FutureBuilder(
            future: getproductdetials(id),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Error: ${snapshot.error}'));
              } else {
                List productDataList = snapshot.data;
                double total = 0;
                for (var productData in productDataList) {
                  total += productData[2];
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: productDataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(productDataList[index][3]),
                            title: Text(productDataList[index][0]),
                            trailing:
                                Text("Price: ₹${productDataList[index][2]}"),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          "Total:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text(
                          "₹$total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                   Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: CustomLoginButton(text:  "go to payments", onPress: (){
                                   Navigator.pushNamed(context, Routes.payment,
                                arguments: productDataList);
                                 }),
                               )
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

dynamic getproductdetials(List idlist) async {
  List productdatalist = [];
  for (var id in idlist) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("products")
        .where("productid", isEqualTo: id)
        .get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
    productdatalist.add([
      productData["productName"],
      productData["userEmail"],
      productData["price"],
      productData["imageUrls"][0],
      id,
      productData["stock"]
    ]);
  }
  print(productdatalist);
  return productdatalist;
}
