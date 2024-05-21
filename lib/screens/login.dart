// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/routes.dart';
import 'package:eshop_user/config/styles.dart';
import 'package:eshop_user/screens/forgotpassword.dart';
import 'package:eshop_user/widgets/button.dart';
import 'package:eshop_user/widgets/reuabletextfield.dart';
import 'package:eshop_user/widgets/textbox.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Please fill in all fields."),
          );
        },
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, Routes.roothome);
        }
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.message ?? "An error occurred."),
            );
          },
        );
      } catch (e) {
        print("Unexpected error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sign in",
                  style: Styles.title(context),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "Welcome back. Please sign in to continue.",
                style: Styles.subtitlegrey(context),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Textbox(
                hideText: false,
                tcontroller: emailController,
                type: TextInputType.emailAddress,
                hinttext: 'Email',
                icon: Icon(Icons.email, color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 13),
              Textbox(
                hideText: true,
                tcontroller: passwordController,
                type: TextInputType.visiblePassword,
                hinttext: 'Password',
                icon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: Text("Forgot password",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              CustomLoginButton(
                text: "Sign in",
                onPress: () async {
                  await login();
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.register);
                    },
                    child: Text("Sign up",
                        style: TextStyle(color: Theme.of(context).primaryColor)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
