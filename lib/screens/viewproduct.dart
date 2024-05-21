import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:flutter/widgets.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {

  double calculateOverallRating(List<Map<String, dynamic>> dataList) {
  if (dataList.isEmpty) {
    return 0.0; // Handle empty list case (optional)
  }

  // Check if all elements have a 'rating' key
  if (!dataList.every((item) => item.containsKey('rating'))) {
    throw Exception("Error: Not all elements have a 'rating' key");
  }

  // Extract ratings and calculate the average
  List<double> ratings = dataList.map((item) => item['rating'] as double).toList();
  double overallRating = ratings.reduce((a, b) => a + b) / ratings.length;

  return overallRating;
}

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = data["id"]; //  final email=data["email"];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("productid", isEqualTo: id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final productData = snapshot.data!.docs;
          final productDoc = productData.first;
          final documentId = productDoc.id;
          final productMap = productData.first.data() as Map<String, dynamic>;
          final sellerName = productMap["userEmail"];
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MyConstants.screenHeight(context) * 0.01),
                child: CarouselSlider.builder(
                  itemCount: productMap["imageUrls"].length,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 1,
                    height: MyConstants.screenHeight(context) * 0.5,
                  ),
                  itemBuilder: (BuildContext context, int index, _) {
                    return Image.network(
                      productMap["imageUrls"][index],
                      fit: BoxFit.scaleDown,
                    );
                  },
                ),
              ),
              ProductAndDescription(
                productName: productMap["productName"],
                description: productMap["description"],
                price: productMap["price"],
                stock: productMap["stock"],
                category: productMap["category"],
                sellerName: sellerName,
                ratingsAndFeedbacks:productMap.containsKey("ratingsAndFeedbacks")?productMap["ratingsAndFeedbacks"].cast<Map<String, dynamic>>():null,
                overallRating: productMap.containsKey("ratingsAndFeedbacks")?calculateOverallRating(productMap["ratingsAndFeedbacks"].cast<Map<String, dynamic>>()):0.0,
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("products")
                      .doc(documentId)
                      .update({"stock": productMap["stock"] + 1});
                },
              )
            ],
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: MyConstants.screenHeight(context) * 0.07,
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                String? userEmail = FirebaseAuth.instance.currentUser?.email;

                updatecart(userEmail, id, context);
              },
              child: Container(
                color: Colors.green.shade100,
                child: Center(
                  child: Text(
                    "add to cart",
                    style: TextStyle(
                        fontSize: MyConstants.screenHeight(context) * 0.026,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.odrsumm, arguments: [id]);
              },
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Buy now",
                    style: TextStyle(
                        fontSize: MyConstants.screenHeight(context) * 0.026,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class ProductAndDescription extends StatelessWidget {
  final String productName;
  final String description;
  final dynamic price;
  final dynamic stock;
  final String category;
  final String sellerName;
  final dynamic onPressed;
  final List<Map<String,dynamic>>? ratingsAndFeedbacks;
  final double overallRating;
  const ProductAndDescription(
      {super.key,
      required this.productName,
      required this.sellerName,
      required this.category,
      required this.description,
      required this.price,
      required this.stock,
      required this.onPressed,
      this.ratingsAndFeedbacks,
      required this.overallRating
      });

  @override
  Widget build(BuildContext context) {
    print("rating and feedback : $ratingsAndFeedbacks");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹ $price",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "category : $category",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "stock : ${stock.toString().split(".")[0]}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "seller : $sellerName",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          overallRating==0.0?
          const Padding(
            padding:  EdgeInsets.all(20),
            child: ListTile(
              tileColor: Colors.greenAccent,
                leading:  Text("Overall rating"),
                title:  Text("No rating yet"),
                // trailing: MaterialButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, Routes.ratings,arguments: ratingsAndFeedbacks);
                //   },
                //   child: const Text("see more"),
                // ),
              ),
          ):
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              tileColor: Colors.greenAccent,
                leading: const Text("Overall rating"),
                title: Text(overallRating.toString()),
                trailing: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.ratings,arguments: ratingsAndFeedbacks);
                  },
                  child: const Text("see more"),
                ),
              ),
          )
        ],
      ),
    );
  }
}

void updatecart(
    String? userEmail, String productId, BuildContext context) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("users")
      .where("email", isEqualTo: userEmail)
      .get();
  var doc = snapshot.docs.first;
  Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

  List<dynamic> cart = userData["cart"] ?? [];

  if (cart.contains(productId)) {
    return showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("Product already exists in the cart.")],
            ),
          ),
        );
      },
    );
  } else {
    cart.add(productId);

    await doc.reference.update({"cart": cart});
    print("Product added to cart: $productId");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("Product added to cart")],
            ),
          ),
        );
      },
    );
  }
}

Future<String> getSellerName(String email) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("seller")
      .where("email", isEqualTo: email)
      .get();

  if (snapshot.docs.isNotEmpty) {
    var doc = snapshot.docs.first;
    Map<String, dynamic> sellerData = doc.data() as Map<String, dynamic>;
    String sellerName = sellerData["companyname"];
    print("--------- $sellerName");
    return sellerName;
  } else {
    return ""; // Or return a default value if seller not found
  }
}

String getName(String email) {
  String seller = "";
  getSellerName(email).then((value) {
    seller = value;
    print("############ $seller");
  });
  return seller;
}
