import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eshop_user/config/configuration.dart';
import 'package:eshop_user/widgets/reuabletextfield.dart';



class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController pincodecontroller = TextEditingController();
  TextEditingController districtcontroller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
    TextEditingController housecontroller = TextEditingController();

  Future <void> update(String id) async{
   
      
    
    await FirebaseFirestore.instance.collection("users").doc(id).update({
    
    "username": usernamecontroller.text.trim(),
    "phone": phoneController.text.trim(),
    "Steetadress": addressController.text.trim(),
    "pincode": pincodecontroller.text.trim(),
    "district": districtcontroller.text.trim(),
   "state": statecontroller.text.trim(),
    "housename": housecontroller.text.trim(),
  });
    }

  @override
  Widget build(BuildContext context) {
      final String documentId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "E D I T   P R O F I L E",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            
              // Reusabletextfield(
              //     controller: usernamecontroller,
              //     isobscure: false,
              //     inputtype: TextInputType.text,
              //     hint: "username"),
              Reusabletextfield(
                  controller: phoneController,
                  isobscure: false,
                  inputtype: TextInputType.number,
                  hint: "phone"),
              Reusabletextfield(
                  controller: addressController,
                  isobscure: false,
                  inputtype: TextInputType.text,
                  hint: "adress"),
              Reusabletextfield(
                  controller: housecontroller,
                  isobscure: false,
                  inputtype: TextInputType.text,
                  hint: "house name"),
              Reusabletextfield(
                  controller: pincodecontroller,
                  isobscure: false,
                  inputtype: TextInputType.number,
                  hint: "pincode"),
                   Reusabletextfield(
                  controller: districtcontroller,
                  isobscure: false,
                  inputtype: TextInputType.text,
                  hint: "district"),
                   Reusabletextfield(
                  controller: statecontroller,
                  isobscure: false,
                  inputtype: TextInputType.text,
                  hint: "state"),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                  child: MaterialButton(
                      onPressed: () {
                        if (
                            phoneController.text == "" ||
                            addressController.text == "" ||
                            usernamecontroller.text == "" ||
                            pincodecontroller.text == "" ||
                            districtcontroller.text == "") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text("fill all fields")],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                        
                          update(documentId);
                         Navigator.pop(context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MyConstants.screenHeight(context) * 0.01)),
                      color: Theme.of(context).colorScheme.primary,
                      elevation: 10,
                      child: Text(
                        "save",
                        style: TextStyle(
                            fontSize: MyConstants.screenHeight(context) * 0.025),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
