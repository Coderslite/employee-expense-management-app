import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:employee_expense_management/screens/expense_screen.dart';
import 'package:employee_expense_management/screens/home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TransactionEditScreen extends StatefulWidget {
  final String date;
  final String amount;
  final String merchant;
  final String note;
  final String receiptUrl;
  final String receiptExt;
  final String docID;
  const TransactionEditScreen({
    Key? key,
    required this.amount,
    required this.merchant,
    required this.note,
    required this.date,
    required this.receiptUrl,
    required this.receiptExt,
    required this.docID,
  }) : super(key: key);

  @override
  State<TransactionEditScreen> createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  bool isLoading = false;
  Timer? _timer;
  final _formKey = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd");
  File? file;
  String? fileExtension;
  DateTime? date;

  String? amount;
  String? merchant;
  String? note;
  var receiptUrl = '';

  final List<String> genderItems = [
    'Hotel',
    'Office Supplies',
    'Rental Cars',
    'Parking',
    'Taxi',
    'Electronic',
    'Resturant',
    'Airline',
    'Shuttle',
    'Fast Food',
    'Shuttle Sharing',
    'Breakfasr',
  ];

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
                    const Text("Total"),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      // inputFormatters: [
                      //   MoneyInputFormatter(
                      //     // leadingSymbol: "NGN",
                      //   ),
                      // ],
                      initialValue: widget.amount,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        // FormBuilderValidators.numeric(context),
                      ]),
                      decoration: InputDecoration(
                        hintText: 'please enter the amount (NGN)',
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
                        amount = e;
                      },
                      onChanged: (e) {
                        amount = e;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Merchant"),
                    DropdownButtonFormField2(
                      value: widget.merchant,
                      selectedItemHighlightColor: Colors.deepPurple,
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(context),
                      // ]),

                      decoration: InputDecoration(
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
                      isExpanded: true,
                      hint: const Text(
                        'Select Category',
                        // style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      // buttonHeight: 60,
                      // buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),

                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        merchant = value.toString();
                      },
                      onSaved: (value) {
                        merchant = value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Date"),
                    DateTimeField(
                      format: format,
                      // initialValue: DateTime.parse(widget.date.toString()),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        return date;
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      decoration: InputDecoration(
                        hintText: 'choose date',
                        // prefix: const Icon(
                        //   Icons.calendar_today,
                        //   color: Colors.deepPurple,
                        // ),
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
                        date = e;
                      },
                      onChanged: (e) {
                        date = e;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Note"),
                    TextFormField(
                      initialValue: widget.note,
                      keyboardType: TextInputType.text,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      // inputFormatters: [
                      //   MoneyInputFormatter(
                      //     leadingSymbol: "NGN",
                      //   ),
                      // ],
                      onSaved: (e) {
                        note = e;
                      },
                      onChanged: (e) {
                        note = e;
                      },
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 300,
                      decoration: InputDecoration(
                        hintText: 'Write brief note on the espenses',
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
                    ),
                    GestureDetector(
                      onTap: () {
                        pickFile();
                      },
                      child: widget.receiptUrl == ''
                          ? const Text("Click to attach a receipt (optional)")
                          : widget.receiptExt == 'jpg'
                              ? file == null
                                  ? Image.network(widget.receiptUrl)
                                  : Image.file(file!)
                              : Row(children: [
                                  Image.asset(
                                    'assets/images/profile-img.jpg',
                                    width: 100,
                                  )
                                ]),
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

                    handleAddExpense(amount.toString(), merchant.toString(),
                        date!, note.toString(), file.toString());
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
                            "Update Expense",
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

  pickFile() async {
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
      var ext = result.files.single.extension;
      fileExtension = ext;
      // print(ext);
    } else {
      // User canceled the picker
    }
  }

  // handleReceiptUpload(File file) async {
  //   // singleImage = File(img.path);

  // }

  handleAddExpense(String amount, String merchant, DateTime date, String note,
      String receipt) async {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      if (file != null && widget.receiptUrl != '') {
        _formKey.currentState!.save();

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('expense/')
            .child(note);
        firebase_storage.UploadTask task = ref.putFile(file!);
        firebase_storage.TaskSnapshot snapshot = await task;
        receiptUrl = await snapshot.ref.getDownloadURL();

        var newDate = DateFormat('EEE, M/d/y').format(date);
        // print(expense);
        Map<String, dynamic> expense = {
          'amount': amount,
          'merchant': merchant,
          'date': newDate,
          'note': note,
          'receipt': receiptUrl
        };
        FirebaseFirestore.instance
            .collection("expense")
            .doc(widget.docID)
            .update(expense)
            .then((value) async {
          setState(() {
            isLoading = false;
          });
          _timer?.cancel();
          await EasyLoading.showSuccess('Expense Updated Successfully')
              .whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return Home();
            }));
          });
          print('data added');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        var newDate = DateFormat('EEE, M/d/y').format(date);
        // print(expense);
        Map<String, dynamic> expense = {
          'amount': amount,
          'merchant': merchant,
          'date': newDate,
          'note': note,
        };
        FirebaseFirestore.instance
            .collection("expense")
            .doc(widget.docID)
            .update(expense)
            .then((value) async {
          setState(() {
            isLoading = false;
          });
          _timer?.cancel();
          await EasyLoading.showSuccess('Expense Updated Successfully')
              .whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const ExpenseScreen();
            }));
          });

          print('data added');
        });
        // print(expense);
      }
    }
  }
}
