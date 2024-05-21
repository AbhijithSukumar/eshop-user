import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
    Map<String, bool> wishlistStates = {}; 
  @override
  Widget build(BuildContext context) {
    final category=ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppBar(
      title:  Text(category,
      style: const TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
     body: Padding(
        padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("products").where("category",isEqualTo: category).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('There are no products currently in this category.'));
            }

            final userData = snapshot.data!.docs;

            return GridView.builder(
              itemCount: userData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.73),
              itemBuilder: (BuildContext context, int index) {
                final userDoc = userData[index];
                final documentId = userDoc.id;
                final Map<String, dynamic> userMap = userDoc.data() as Map<String, dynamic>;
                final String image = userMap["imageUrls"]?[0] ?? '';
                final String name = userMap["productName"] ?? '';
                final double price = userMap["price"] ?? '';
                final isLiked = wishlistStates[documentId] ?? false;

                return GestureDetector(
                  onTap:() {
                    Navigator.pushNamed(context, Routes.viewproduct,arguments: userMap["productid"]);
                  },
                  child: SizedBox(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: MyConstants.screenHeight(context) * 0.25,
                              child: Image.network(image, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: MyConstants.screenHeight(context) * 0.01,
                              right: MyConstants.screenHeight(context) * 0.01,
                              child: IconButton(
                                onPressed: () {
                                  updateWishlist(FirebaseAuth.instance.currentUser!.email, documentId);
                                },
                                icon: isLiked ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_outline, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            name,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "₹ $price",
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
   void updateWishlist(String? userEmail, String productId) async {
    
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
      var doc = snapshot.docs.first;
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

      List<dynamic> wishlist = userData["wishlist"] ?? [];

      if (wishlist.contains(productId)) {
        wishlist.remove(productId);
      } else {
        wishlist.add(productId);
      }

      await doc.reference.update({"wishlist": wishlist});

     
      setState(() {
        wishlistStates[productId] = wishlist.contains(productId);
      });

  }

  @override
  void initState() {
    super.initState();
    initializeWishlistStates(); 
  }

  void initializeWishlistStates() async {
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
      var doc = snapshot.docs.first;
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      List<dynamic> wishlist = userData["wishlist"] ?? [];
      for (var productId in wishlist) {
        setState(() {
          wishlistStates[productId] = true; 
        });
      }
  }
}
