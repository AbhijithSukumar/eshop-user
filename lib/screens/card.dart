import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/screens/payments.dart';

class CardData extends StatefulWidget {
  const CardData({super.key});

  @override
  State<CardData> createState() => _CardDataState();
}

class _CardDataState extends State<CardData> {
   final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data1= ModalRoute.of(context)?.settings.arguments as List;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Card Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListTile(
                leading:IconButton(onPressed: (){
                  showDialog(context: context, builder: (BuildContext context) { 
                          return AlertDialog(
      title: const Text('Enter Card Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cardNumberController,
            decoration: const InputDecoration(labelText: 'Card Number'),
          ),
          TextField(
            controller: cvvController,
            decoration: const InputDecoration(labelText: 'CVV'),
          ),
           TextField(
            controller: expiryController,
            decoration: const InputDecoration(labelText: 'Expiry'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async{
              await FirebaseFirestore.instance.collection("card").add( {
              'cardNumber': cardNumberController.text.trim(),
              'cvv': cvvController.text.trim(),
              'expiry':expiryController.text.trim(),
              "email": FirebaseAuth.instance.currentUser?.email,
            });
            Navigator.pop(context);
              
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          child: const Text('Cancel'),
        ),
      ],
    );
                   }, );
                }, icon: Icon(Icons.add)),
                title: Text("Add Card Details",style: Theme.of(context).textTheme.headlineMedium,),
              ),
            ),
          ),
           Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
        .collection("card")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }

                  return ListView(
                    children: snapshot.data?.docs.map((DocumentSnapshot document) {
                      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                             placeOrder(data1);
    Navigator.pushNamed(context, Routes.confirm);
                            },
                            title: Text(data['cardNumber']),
                            subtitle: Text(data['expiry']),
                            trailing: IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection("card").doc(document.id).delete();
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      );
                    }).toList() ?? [],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}