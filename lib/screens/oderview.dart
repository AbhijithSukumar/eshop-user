// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_user/screens/ordersummary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/widgets/mytimetile.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  Future<bool> hasUserRated(String productId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('productid', isEqualTo: productId)
        .get();

    if (snapshot.docs.isEmpty) {
      return false;
    }

    final document = snapshot.docs.first;
    final ratingsAndFeedbacks = document.data()['ratingsAndFeedbacks'] as List?;

    if (ratingsAndFeedbacks == null || ratingsAndFeedbacks.isEmpty) {
      return false;
    }

    // Check if user with current email has already rated
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    return ratingsAndFeedbacks
        .any((rating) => rating['username'] == currentUserEmail);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    print("iddddddddddddddddddddddddddddddd $id");
    if (id == null) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Text('No order ID provided.'),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            "O R D E R  D E T I A L S",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("id", isEqualTo: id)
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
              return const Center(child: Text('No Orders data found.'));
            }
      
            final orderMap = ordersData.first.data() as Map<String, dynamic>;
            final productId = orderMap["product id"];
            print("piddddddddddddddddd $productId");
            final objectId=ordersData.first.id;
            return FutureBuilder<bool>(
                future: hasUserRated(productId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
      
                  if (snapshot.hasError) {
                    print('Error checking user rating: ${snapshot.error}');
                    return const Center(child: Text('Error checking rating'));
                  }
      
                  final hasRated = snapshot.data ?? false;
                  print("haaaaaaaaaaaaaaaas rated : $hasRated");
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: ListTile(
                              title: Text(
                                orderMap["product name"],
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "₹ ${orderMap["price"]} ",
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(orderMap["image"])),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Mytimetile(
                                  isfirst: true,
                                  islast: false,
                                  ispast: orderMap["order placed"],
                                  text: 'order placed',
                                ),
                                Mytimetile(
                                  isfirst: false,
                                  islast: false,
                                  ispast: orderMap["order shipped"],
                                  text: 'shipped',
                                ),
                                Mytimetile(
                                  isfirst: false,
                                  islast: false,
                                  ispast: orderMap["out for delivery"],
                                  text: 'out for delivery',
                                ),
                                Mytimetile(
                                  isfirst: false,
                                  islast: true,
                                  ispast: orderMap["order delivered"],
                                  text: 'order delivered',
                                ),
                                if (orderMap["order delivered"] == true)
                                  if (!hasRated)
                                    UpdateRating(documentId: orderMap["product id"]),
                                if (hasRated)
                                 DisplayRating(
                                            documentId: orderMap["product id"],)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}



class UpdateRating extends StatefulWidget {
  final String documentId;
  
  const UpdateRating({Key? key, required this.documentId}) : super(key: key);

  @override
  State<UpdateRating> createState() => _UpdateRatingState();
}

class _UpdateRatingState extends State<UpdateRating> {
  double rating = 0.0;
  String feedback = "";
  bool hasRated = false;
  String id="";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  
  Future<void> getProductid()async{
   final collection = await _firestore
        .collection('products')
        .where('productid', isEqualTo: widget.documentId)
        .get();
      final document=collection.docs.first;
      id=document.id;
}

  Future<void> _checkHasRated() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail == null) return;

    final snapshot = await _firestore
        .collection('products')
        .where('productid', isEqualTo: widget.documentId)
        .get();

    if (snapshot.docs.isEmpty) return;

    final document = snapshot.docs.first;
    final ratingsAndFeedbacks = document.data()['ratingsAndFeedbacks'] as List?;

    if (ratingsAndFeedbacks == null || ratingsAndFeedbacks.isEmpty) return;

    hasRated = ratingsAndFeedbacks.any((rating) => rating['username'] == currentUserEmail);
  }

  @override
  void initState() {
    super.initState();
    _checkHasRated();
    getProductid();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Please add your ratings (You can update your existing rating)"),
            Slider(
              value: rating,
              min: 0.0,
              max: 5.0,
              divisions: 5,
              label: 'Rating: $rating',
              onChanged: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Feedback',
              ),
              onChanged: (newValue) {
                setState(() {
                  feedback = newValue;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitRatingAndFeedback,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRatingAndFeedback() async {
    final firestore = FirebaseFirestore.instance;
    final productId = widget.documentId;
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail == null) return;

    final docRef = firestore.collection('products').doc(id);

    await docRef.update({
      'ratingsAndFeedbacks': FieldValue.arrayUnion([
        {
          'rating': rating,
          'feedback': feedback,
          'username': currentUserEmail,
        },
      ]),
    });

    print('Rating and feedback added!');
    setState(() {
      
    });
  }

  
}

class DisplayRating extends StatefulWidget {
  final String documentId;

   DisplayRating({super.key, required this.documentId});

  @override
  State<DisplayRating> createState() => _DisplayRatingState();
}

class _DisplayRatingState extends State<DisplayRating> {
  double rating = 0.0;

  String feedback = "";

  bool hasRated = false;

  String id="";

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<void> _updateRatingAndFeedback() async {
    final firestore = FirebaseFirestore.instance;
    final productId = widget.documentId;
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail == null) return;

    final docRef = firestore.collection('products').doc(id);

    // Get current ratings and feedback for the user
    final snapshot = await docRef.get();
    final ratingsAndFeedbacks = snapshot.data()!['ratingsAndFeedbacks'] as List?;

    if (ratingsAndFeedbacks == null || ratingsAndFeedbacks.isEmpty) return;

    final userRatingIndex = ratingsAndFeedbacks.indexWhere(
        (rating) => rating['username'] == currentUserEmail);

    if (userRatingIndex == -1) return;

    // Update the rating and feedback at the user's index
    ratingsAndFeedbacks[userRatingIndex] = {
      'rating': rating,
      'feedback': feedback,
      'username': currentUserEmail,
    };

    await docRef.update({
      'ratingsAndFeedbacks': ratingsAndFeedbacks,
    });

    print('Rating and feedback updated!');
    setState(() {
      
    });
  }

   Future<void> getProductid()async{
   final collection = await _firestore
        .collection('products')
        .where('productid', isEqualTo: widget.documentId)
        .get();
      final document=collection.docs.first;
      id=document.id;
}

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;
        List<Map<String, dynamic>> ratingsAndFeedbacks = [];

        for (final doc in documents) {
          if (doc['productid'] == widget.documentId) {
            ratingsAndFeedbacks = doc['ratingsAndFeedbacks']?.cast<Map<String, dynamic>>() ?? [];
            break;
          }
        }

        return ratingsAndFeedbacks.isEmpty
            ? const Center(child: Text('No Ratings Yet'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: ratingsAndFeedbacks.length,
                itemBuilder: (context, index) {
                  final rating = ratingsAndFeedbacks[index]['rating'] ?? 0.0;
                  final feedback = ratingsAndFeedbacks[index]['feedback'] ?? '';
                  final username = ratingsAndFeedbacks[index]['username'] ?? '';

                  return ListTile(
                    title: Text('Rating: $rating'),
                    subtitle: Text('Feedback: $feedback by $username'),
                  );
                },
              );
      },
    );
  }
}


