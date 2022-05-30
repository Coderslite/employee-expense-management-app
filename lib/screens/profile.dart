import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_expense_management/screens/home.dart';
import 'package:employee_expense_management/screens/login.dart';
import 'package:employee_expense_management/screens/profile_edit.dart';
import 'package:employee_expense_management/screens/view_full_imgae.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  File? file;
  String? imageUrl;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
            bottom: 20,
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("official_account")
                  .where('email', isEqualTo: user!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs[0];
                  var docID = data.id;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return const Home();
                              }));
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const Text("  "),
                          const Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return ViewFullImage(
                                                    image: data['image'] == ''
                                                        ? "https://www.w3schools.com/w3images/avatar2.png"
                                                        : data['image']);
                                              }));
                                            },
                                            title: Text("View Image"),
                                            leading: Icon(Icons.visibility),
                                          ),
                                          ListTile(
                                            title: Text("Change Image"),
                                            leading: Icon(Icons.file_upload),
                                            onTap: () {
                                              handleUploadImage(docID);
                                            },
                                          ),
                                          const ListTile(
                                            title: Text(
                                              "Delete Image",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            leading: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                data['image'] == ''
                                    ? "https://www.w3schools.com/w3images/avatar2.png"
                                    : data['image'],
                              ),
                              radius: 50,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Material(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(15),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ProfileEditScreen(
                                      name: data['name'],
                                      email: data['email'],
                                      phone: data['phone'],
                                      address: data['address'],
                                      docID: docID);
                                }));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Update Profile",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Personal Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['name'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['email'],
                            style: const TextStyle(
                                // fontSize: 20,
                                ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['phone'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['address'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Official Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['role'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['reg_no'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Material(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        child: MaterialButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return const LoginScreen();
                              }));
                            });
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: const Text("Loading ....."));
              }),
        ),
      ),
    );
  }

  // pickFile() async {

  // }

  handleUploadImage(String docID) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'jpg',
      'pdf',
      'doc',
    ]);

    if (result != null) {
      setState(() {
        file = File(result.files.single.path.toString());
      });
      // var ext = result.files.single.extension;
      // fileExtension = ext;
      // print(ext);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('official_account/')
          .child(user!.email.toString());
      firebase_storage.UploadTask task = ref.putFile(file!);
      firebase_storage.TaskSnapshot snapshot = await task;
      imageUrl = await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection("official_account")
          .doc(docID)
          .update(
        {'image': imageUrl},
      ).whenComplete(() async {
        await EasyLoading.showSuccess('Document Deleted Successfully!')
            .then((value) {});
      });
    } else {
      // User canceled the picker
    }
  }
}
