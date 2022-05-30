import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:employee_expense_management/screens/expense_screen.dart';
import 'package:employee_expense_management/screens/home.dart';
import 'package:employee_expense_management/screens/profile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileEditScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String docID;
  const ProfileEditScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.docID,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool isLoading = false;
  Timer? _timer;
  final _formKey = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd");

  String? name;
  String? phone;
  String? address;

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            bottom: 100,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Edit Transaction",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(""),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name"),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      // inputFormatters: [
                      //   MoneyInputFormatter(
                      //     // leadingSymbol: "NGN",
                      //   ),
                      // ],
                      initialValue: widget.name,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        // FormBuilderValidators.numeric(context),
                      ]),
                      decoration: InputDecoration(
                        hintText: 'please enter the new name',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      onSaved: (e) {
                        name = e;
                      },
                      onChanged: (e) {
                        name = e;
                      },
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // const Text("Email"),
                    // TextFormField(
                    //   keyboardType: TextInputType.emailAddress,
                    //   // inputFormatters: [
                    //   //   MoneyInputFormatter(
                    //   //     // leadingSymbol: "NGN",
                    //   //   ),
                    //   // ],
                    //   initialValue: widget.email,
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(context),
                    //     // FormBuilderValidators.numeric(context),
                    //   ]),
                    //   decoration: InputDecoration(
                    //     hintText: 'please enter the amount (NGN)',
                    //     border: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: Colors.deepPurple,
                    //         ),
                    //         borderRadius: BorderRadius.circular(15)),
                    //     enabledBorder: const OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.deepPurple,
                    //       ),
                    //     ),
                    //   ),
                    //   onSaved: (e) {
                    //     amount = e;
                    //   },
                    //   onChanged: (e) {
                    //     amount = e;
                    //   },
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Phone Number"),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      // inputFormatters: [
                      //   MoneyInputFormatter(
                      //     // leadingSymbol: "NGN",
                      //   ),
                      // ],
                      initialValue: widget.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        // FormBuilderValidators.numeric(context),
                      ]),
                      decoration: InputDecoration(
                        hintText: 'please enter the new phone number',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      onSaved: (e) {
                        phone = e;
                      },
                      onChanged: (e) {
                        phone = e;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Address"),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      // inputFormatters: [
                      //   MoneyInputFormatter(
                      //     // leadingSymbol: "NGN",
                      //   ),
                      // ],
                      initialValue: widget.address,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        // FormBuilderValidators.numeric(context),
                      ]),
                      decoration: InputDecoration(
                        hintText: 'please enter the new address',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      onSaved: (e) {
                        address = e;
                      },
                      onChanged: (e) {
                        address = e;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(15),
                child: MaterialButton(
                  onPressed: () async {
                    _formKey.currentState!.save();

                    handleUpdateProfile(
                        name.toString(), phone.toString(), address.toString());
                    // _formKey.currentState!.save();
                    // print(file);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Update Profile",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // handleReceiptUpload(File file) async {
  //   // singleImage = File(img.path);

  // }

  handleUpdateProfile(
    String name,
    String phone,
    String address,
  ) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      // print(expense);
      Map<String, dynamic> profile = {
        'name': name,
        'phone': phone,
        'address': address,
      };
      FirebaseFirestore.instance
          .collection("official_account")
          .doc(widget.docID)
          .update(profile)
          .then((value) async {
        setState(() {
          isLoading = false;
        });
        _timer?.cancel();
        await EasyLoading.showSuccess('Profile Updated Successfully')
            .whenComplete(() {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProfileScreen();
          }));
        });
        print('data added');
      });
    }
  }
}
