import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_expense_management/screens/expense_screen.dart';
import 'package:employee_expense_management/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  bool isSelected = false;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
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
                  "Expenses History",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(""),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("expense")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("something went wrong");
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No data found"),
                      );
                    }
                    return Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var docID = snapshot.data!.docs[index].id;
                              var data = snapshot.data!.docs[index];
                              return Dismissible(
                                  background: Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    color: Colors.red,
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  key: UniqueKey(),
                                  onDismissed: (direction) async {
                                    handleDelete(docID);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return const ExpenseScreen();
                                      }));
                                    },
                                    child: ListTile(
                                      key: UniqueKey(),
                                      title: Text(
                                        data['merchant'],
                                      ),
                                      subtitle: Text(
                                        "NGN" + data['amount'],
                                      ),
                                      trailing: Text(
                                        data['date'],
                                      ),
                                      leading: data['receipt'] == ''
                                          ? CircleAvatar(
                                              child: Icon(Icons.receipt),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                data['receipt'],
                                              ),
                                            ),
                                      isThreeLine: true,
                                    ),
                                  ));
                            }),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  }
                  return const Text("loading ...");
                }),
          ],
        ),
      ),
    );
  }

  handleDelete(docID) async {
    FirebaseFirestore.instance
        .collection("expense")
        .doc(docID)
        .delete()
        .then((e) async {
      _timer?.cancel();

      await EasyLoading.showSuccess('Document Deleted Successfully!')
          .whenComplete(() {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return const Home();
        }));
      });
    });
  }
}
