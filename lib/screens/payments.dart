// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as List;
    print(data);
    final payprovider = Provider.of<PaymentMethodProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "P A Y M E N T S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const PaymentMethodTile(title: "UPI", value: "UPI"),
            const PaymentMethodTile(title: "Debit/Credit Card", value: "Card"),
            const PaymentMethodTile(title: "Net Banking", value: "Net Banking"),
            const PaymentMethodTile(
                title: "Cash on Delivery", value: "Cash on Delivery"),
            const PaymentMethodTile(title: "Wallet", value: "Wallet"),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  if (payprovider.selectedPaymentMethod == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            color: Theme.of(context).colorScheme.secondary,
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Please select a payment method")
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (payprovider.selectedPaymentMethod ==
                      "Cash on Delivery") {
                    placeOrder(data);
                    Navigator.pushNamed(context, Routes.confirm);
                  } else if (payprovider.selectedPaymentMethod == "Card") {
                    Navigator.pushNamed(context, Routes.card, arguments: data);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            color: Theme.of(context).colorScheme.secondary,
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Coming soon, only Cash on Delivery is available at the moment")
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MyConstants.screenHeight(context) * 0.01),
                ),
                color: Theme.of(context).colorScheme.primary,
                elevation: 10,
                child: Text(
                  "Place order",
                  style: TextStyle(
                      fontSize: MyConstants.screenHeight(context) * 0.025),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String value;
  

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.value,
    
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentMethodProvider>(
      builder: (context, paymentMethodProvider, _) => ListTile(
        title: Text(title),
        leading: Radio<String>(
          value: value,
          groupValue: paymentMethodProvider.selectedPaymentMethod,
          onChanged: (String? newValue) {
            paymentMethodProvider.setSelectedPaymentMethod(newValue);
          },
        ),
      ),
    );
  }
}

class PaymentMethodProvider extends ChangeNotifier {
  String? _selectedPaymentMethod;

  String? get selectedPaymentMethod => _selectedPaymentMethod;

  void setSelectedPaymentMethod(String? method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}

void placeOrder(List orderList) async {
  for (var order in orderList) {
    Map<String, dynamic> orderdata = {
      "id": Uuid().v1(),
      "image": order[3],
      "product name": order[0],
      "product id":order[4],
      "seller email": order[1],
      "price": order[2],
      "buyer email": FirebaseAuth.instance.currentUser!.email,
      "order placed": true,
      "order shipped": false,
      "out for delivery": false,
      "order delivered": false,
      "payment type": "Cash on Delivery",
      "timestamp": Timestamp.now()
    };
    print(orderdata);
    await FirebaseFirestore.instance.collection("orders").add(orderdata);
     
     final FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference collectionReference = firestore.collection('products');

Query query = collectionReference.where('productid', isEqualTo: order[4]).limit(1); // Limit to 1 matching doc
final querySnapshot = await query.get();
if (querySnapshot.docs.isNotEmpty) {
    // Document found, get its reference and update
    DocumentReference documentReference = querySnapshot.docs[0].reference;
    await documentReference.update({"stock":order[5]-1});
    print('Document updated successfully!');
  } else {
    print('No document found with email: ${order[5]}');
  }
  }
  if (orderList.length == 1) {
    print("not in cart");
  } else {
    print("in cart");
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    DocumentSnapshot userDoc = snapshot.docs.first;

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    userData["cart"] = [];

    await userDoc.reference.update(userData);
  }
}
