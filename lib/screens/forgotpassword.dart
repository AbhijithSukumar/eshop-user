// ignore_for_file: use_build_context_synchronously


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/widgets/reuabletextfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  dynamic resetpassword()async{
 try{
   await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
 showDialog(context: context, builder: (BuildContext context) { 
        return AlertDialog(
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
           child:  Column(
            mainAxisSize: MainAxisSize.min,
             children: [
               const Padding(
                 padding: EdgeInsets.all(8.0),
                 child: Text("email sent to registered email"),
               ),
               ElevatedButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Routes.login);
               }, child: const Text("ok"))
             ],
           ),
          ),
        );
       }, );
       email.clear();
 }
on FirebaseAuthException catch (exception) {
      showDialog(context: context, builder: (BuildContext context) { 
        return AlertDialog(
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
           child:  Text(exception.code.toString()),
          ),
        );
       }, );
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "R E S E T  P A S S W O R D",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Enter your registered email and we will sent you an email to the rregistered email",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Reusabletextfield(
              controller: email,
                isobscure: false,
                inputtype: TextInputType.emailAddress,
                hint: "Email"
            )
          ),
           Padding(
                padding:
                    EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                child: MaterialButton(
                    onPressed: (){
                      resetpassword();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MyConstants.screenHeight(context) * 0.01)),
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 10,
                    child: Text(
                      "get email",
                      style: TextStyle(
                          fontSize: MyConstants.screenHeight(context) * 0.025),
                    )),
              ),
        ],
      ),
    );
  }
}
