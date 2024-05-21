// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/config/styles.dart';
import 'package:eshop_user/widgets/button.dart';
import 'package:eshop_user/widgets/textbox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController housenamecontroller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController districtcontoller = TextEditingController();
  TextEditingController adresscontroller = TextEditingController();
  TextEditingController pincodecontroller = TextEditingController();

  Future<void> addUser() async {
    Map<String, dynamic> usermap = {
      "email": emailcontroller.text.trim(),
      "phone": phonecontroller.text.trim(),
      "housename": housenamecontroller.text.trim(),
      "state": statecontroller.text.trim(),
      "district": districtcontoller.text.trim(),
      "pincode": pincodecontroller.text.trim(),
      "Steetadress": adresscontroller.text.trim(),
      "wishlist": [],
      "cart": [],
    };

    if (usermap["email"] == "" ||
        usermap["housename"] == "" ||
        usermap["phone"] == "" ||
        usermap["Steetadress"] == "" ||
        usermap["state"] == "" ||
        usermap["district"] == "" ||
        usermap["pincode"] == "" ||
        cpasswordcontroller.text.trim() == "" ||
        passwordcontroller.text.trim() == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please fill in all fields"),
                ],
              ),
            ),
          );
        },
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailcontroller.text.trim(),
                password: passwordcontroller.text.trim());
        if (userCredential.user != null) {
          Navigator.pushNamed(context, Routes.login);
        }
      } on FirebaseAuthException catch (exception) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(exception.code.toString()),
                  ],
                ),
              ),
            );
          },
        );
      }
      await FirebaseFirestore.instance.collection("users").add(usermap);
      emailcontroller.clear();
      passwordcontroller.clear();
      cpasswordcontroller.clear();
      companynamecontroller.clear();
      phonecontroller.clear();
      housenamecontroller.clear();
      statecontroller.clear();
      districtcontoller.clear();
      adresscontroller.clear();
      passwordcontroller.clear();
      Navigator.pushNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Sign up",
                    style: Styles.title(context),
                  ),
                ),
                Text(
                  "Welcome back. Please sign up using",
                  style: Styles.subtitlegrey(context),
                ),
                Text(
                  "your social account to continue",
                  style: Styles.subtitlegrey(context),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Textbox(
                  func:(value) {
                        if (value!.isEmpty) {
                          return "Please enter your email address";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)*$")
                            .hasMatch(value)) {
                          return "Invalid email format";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: emailcontroller,
                  type: TextInputType.emailAddress,
                  hinttext: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your mobile number";
                        } else if (!RegExp(
                                r'^[0-9]{10}$').hasMatch(value)) {
                          return "Invalid phone number";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: phonecontroller,
                  type: TextInputType.number,
                  hinttext: 'Phone',
                  icon: Icon(
                    Icons.phone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your housename";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: housenamecontroller,
                  type: TextInputType.text,
                  hinttext: 'housename',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Enter your state";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: statecontroller,
                  type: TextInputType.text,
                  hinttext: 'state',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Enter your district";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: districtcontoller,
                  type: TextInputType.text,
                  hinttext: 'District',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your pincode";
                        } else if (!RegExp(
                                r'^[0-9]{6}$').hasMatch(value)) {
                          return "Invalid pincode";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: pincodecontroller,
                  type: TextInputType.number,
                  hinttext: 'Pincode',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your street address";
                        }
                        return null;
                      },
                  hideText: false,
                  tcontroller: adresscontroller,
                  type: TextInputType.text,
                  hinttext: 'Streetadress',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        } else if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(value)) {
                          return "Invalid password format";
                        }
                        return null;
                      },
                  hideText: true,
                  tcontroller: passwordcontroller,
                  type: TextInputType.visiblePassword,
                  hinttext: 'Password',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  hideText: true,
                  tcontroller: cpasswordcontroller,
                  type: TextInputType.visiblePassword,
                  hinttext: 'Conform password',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                CustomLoginButton(
                  text: "Sign up",
                  onPress: () async {
                    if(_formKey.currentState!.validate())
                    {
                      await addUser();
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.login);
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Reusabletextfield(
//                       controller: emailcontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.emailAddress,
//                       hint: "email"),
//                   Reusabletextfield(
//                       controller: companynamecontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.text,
//                       hint: "user name"),
//                   Reusabletextfield(
//                       controller: phonecontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.number,
//                       hint: "phone number"),
//                   Reusabletextfield(
//                       controller: housenamecontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.visiblePassword,
//                       hint: "housename"),
//                    Reusabletextfield(
//                       controller: statecontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.text,
//                       hint: "state"),
//                   Reusabletextfield(
//                       controller: districtcontoller,
//                       isobscure: false,
//                       inputtype: TextInputType.text,
//                       hint: "district"),  
//                        Reusabletextfield(
//                       controller: pincodecontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.number,
//                       hint: "pincode"),  
//                        Reusabletextfield(
//                       controller: adresscontroller,
//                       isobscure: false,
//                       inputtype: TextInputType.text,
//                       hint: "street adress"),  
                         
//                   Reusabletextfield(
//                       controller: passwordcontroller,
//                       isobscure: true,
//                       inputtype: TextInputType.visiblePassword,
//                       hint: "password"),
//                   Reusabletextfield(
//                       controller: cpasswordcontroller,
//                       isobscure: true,
//                       inputtype: TextInputType.visiblePassword,
//                       hint: "conform password"),
//                   Padding(
//                 padding:
//                     EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
//                 child: MaterialButton(
//                     onPressed: addUser,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                             MyConstants.screenHeight(context) * 0.01)),
//                     color: Theme.of(context).colorScheme.primary,
//                     elevation: 10,
//                     child: Text(
//                       "register",
//                       style: TextStyle(
//                           fontSize: MyConstants.screenHeight(context) * 0.025),
//                     )),
//               ),
//               ],
//             ),
//           ),
//         ),
//       ),