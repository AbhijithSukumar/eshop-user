import "package:flutter/material.dart";
import "package:eshop_user/config/routes.dart";

import "../config/configuration.dart";




class Categorypage extends StatefulWidget {
  const Categorypage({super.key});

  @override
  State<Categorypage> createState() => _CategorypageState();
}

class _CategorypageState extends State<Categorypage> {
  List<List> categories = [
    ["assets/responsive.png","electronics and accessories"],
    ["assets/laptop.png","laptops and computers"],
    ["assets/suit.png","mens clothing"],
    ["assets/woman-clothes.png","womens clothing"],
    ["assets/onesie.png","kids clothing"],
    ["assets/electronics.png","appliances"],
    ["assets/sneakers.png","footwear"],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppBar(
      title: const Text("C A T E G O R Y",
      style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: Padding(
        padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: .8),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                 Navigator.pushNamed(context, Routes.viewcategory,arguments: categories[index][1]);
              },
              child: Padding(

                padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                            width: MyConstants.screenHeight(context)*0.1, 
                            height: MyConstants.screenHeight(context)*0.1, 
                            child: Image.asset(
                              categories[index][0],
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                    Text(categories[index][1],
                    textAlign:TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MyConstants.screenHeight(context)*0.017,
                    
                    ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}