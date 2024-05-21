import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/screens/homescreen.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final datap = Provider.of<WhishListProvider>(context);
    datap.initializeWishlistStates();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "W I S H L I S T",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Consumer<WhishListProvider>(
        builder: (context, data, _) {
          return FutureBuilder(future: findingProducts(), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          if (snapshot.connectionState==ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }
                   // Handle no wishlist data scenario
              if (snapshot.hasData && snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                    'Your wishlist is currently empty.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }

                  List<Product> data=snapshot.data;
            return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
             

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                   onTap: () {
                              Navigator.pushNamed(context, Routes.viewproduct, arguments: {
                                "id":  data[index].pid,
                                "email":  data[index].email,
                              });
                            },
                  child: Card(
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
                                    child: Image.network(
                                      data[index].image,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: MyConstants.screenHeight(context) * 0.01,
                                  right: MyConstants.screenHeight(context) * 0.01,
                                  child:  FutureBuilder(future: isLikedwishlist(data[index].id), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                    if (snapshot.connectionState==ConnectionState.waiting) {
                      return const Icon(Icons.favorite_outline, color: Colors.green);
                    }
                   return IconButton(
                    onPressed: () {
                      datap.updateWishlist(FirebaseAuth.instance.currentUser!.email, data[index].id);
                    },
                    icon: snapshot.data? const Icon(Icons.favorite, color: Colors.green) : const Icon(Icons.favorite_outline, color: Colors.green),
                  );
                   }, )
                  
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                data[index].name.length > 15
                                    ? data[index].name.substring(0, 15)
                                    : data[index].name,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹ ${data[index].price}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );

           },)  ;      },
      ),
    );
  }
}

dynamic findingProducts()async{
QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    List<dynamic> wishlist = userData["wishlist"];
List<Product> product=[];
   for (var id  in wishlist) {
       DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection("products").doc(id).get();

      if (productSnapshot.exists) {
        var productData = productSnapshot.data() as Map<String, dynamic>;
      Product data=Product(name: productData["productName"], description:  productData["description"], price:  productData["price"], image:  productData["imageUrls"][0], id:  id, pid:  productData["productid"], email:  productData["userEmail"]);
     product.add(data);
      }
   }
   return product;
}


class Product{
final String name;
final String description;
final dynamic price;
final String image;
final String id;
final String pid;
final String email;


const  Product({required this.name, required this.description, required this.price, required this.image, required this.id,required this.pid,required this.email,});

}