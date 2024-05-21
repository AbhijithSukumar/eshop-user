import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot>? filteredproducts;
  List<DocumentSnapshot>? products;

  @override
  void initState() {
    super.initState();
    Provider.of<WhishListProvider>(context, listen: false).initializeWishlistStates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
     
      body: Padding(
        padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
        child: Column(

          children: [
            SizedBox(
              height: MyConstants.screenHeight(context) * 0.05 ,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
              
                  controller: searchController,
                  decoration:  InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    hintText: "Search anything",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all( 16),
                    suffixIcon: Icon(Icons.search)
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredproducts = fllteredproducts(value);
                    });
                  },
                ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data found.'));
                }

                products = snapshot.data?.docs;
                List<DocumentSnapshot> displayproducts =
                    searchController.text.isEmpty ? products! : filteredproducts ?? products!;

                return Consumer<WhishListProvider>(
                  builder: (context, data, _) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: displayproducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.63,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final userDoc = displayproducts[index];
                          final documentId = userDoc.id;
                          final Map<String, dynamic> userMap = userDoc.data() as Map<String, dynamic>;
                          final String image = userMap["imageUrls"]?[0] ?? '';
                          final String name = userMap["productName"] ?? '';
                          final double price = userMap["price"] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.viewproduct, arguments: {
                                "id": userMap["productid"],
                                "email": userMap["userEmail"],
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:Card(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MyConstants.screenHeight(context) * 0.23,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(image, fit: BoxFit.cover)),
              ),
              Positioned(
                top: MyConstants.screenHeight(context) * 0.01,
                right: MyConstants.screenHeight(context) * 0.01,
                child: FutureBuilder(future: isLikedwishlist(documentId), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                  if (snapshot.connectionState==ConnectionState.waiting) {
                    return const Icon(Icons.favorite_outline, color: Colors.green);
                  }
                 return IconButton(
                  onPressed: () {
                    data.updateWishlist(FirebaseAuth.instance.currentUser!.email, documentId);
                  },
                  icon: snapshot.data? const Icon(Icons.favorite, color: Colors.green) : const Icon(Icons.favorite_outline, color: Colors.green),
                );
                 }, )
              ),
            ],
          ),
          SizedBox(
            width: double.infinity, // Ensures the text takes full width
            child: Text(
              name.length > 15 ? name.substring(0, 15) : name, // Truncate if longer than 15 chars
              textAlign: TextAlign.left,
              maxLines: 1, // Show only one line
              overflow: TextOverflow.ellipsis, // Add ellipsis (...) if text overflows
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
  ),
),

                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DocumentSnapshot> fllteredproducts(String query) {
    if (query.isEmpty) {
      return [];
    } else {
      List<DocumentSnapshot> filteredList = [];
      for (var product in products!) {
        String productnamename = product["productName"].toLowerCase();
        if (productnamename.contains(query.toLowerCase())) {
          filteredList.add(product);
        }
      }
      return filteredList;
    }
  }
}

class WhishListProvider extends ChangeNotifier {
  Map<String, dynamic> wishListTemp = {};
 List showwishlist=[];
  Map<String, dynamic> get whishList => wishListTemp;

  void updateWishlist(String? userEmail, String productId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    List<dynamic> wishlist = userData["wishlist"];

    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }

    await doc.reference.update({"wishlist": wishlist});

    wishListTemp[productId] = wishlist.contains(productId);
    notifyListeners();
  }

  void initializeWishlistStates() async {
    final userEmail = FirebaseAuth.instance.currentUser!.email;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("products").where("email", isEqualTo: userEmail).get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    List<dynamic> wishlist = userData["wishlist"] ?? [];
    for (var productId in wishlist) {
      wishListTemp[productId] = true;
    }
    notifyListeners();
  }
}


dynamic isLikedwishlist( String documentid)async{
QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    List<dynamic> wishlist = userData["wishlist"];

    if (wishlist.contains(documentid)) {
     return true;
    }
    else{
      return false;
    }
}