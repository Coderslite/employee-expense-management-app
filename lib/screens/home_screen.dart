import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_expense_management/screens/expense_screen.dart';
import 'package:employee_expense_management/screens/profile.dart';
import 'package:employee_expense_management/screens/transaction_history.dart';
import 'package:employee_expense_management/screens/view_full_imgae.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = FirebaseAuth.instance.currentUser;

  int totalExpense = 0;
  int totalIncome = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("official_account")
                    .where('email', isEqualTo: user!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs[0];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return const ProfileScreen();
                            }));
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(data['image'] == ''
                                ? "https://www.w3schools.com/w3images/avatar2.png"
                                : data['image']),
                          ),
                        ),
                        Text(
                          data['role'],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text(
                    "Loading.....",
                    style: TextStyle(color: Colors.white),
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: size.height / 6,
              decoration: BoxDecoration(
                // color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 140, 0, 255), Colors.deepPurple],
                  //begin of the gradient color
                  begin: Alignment.topLeft,
                  //end of the gradient color
                  end: Alignment.bottomRight,
                  stops: [
                    0,
                    0.5,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(''),
                    const Text(
                      "Main Savings",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("expense")
                            .limit(5)
                            .snapshots(),
                        builder: (context, snapshot1) {
                          if (snapshot1.hasError) {
                            return const Text("Something went wrong");
                          }
                          if (snapshot1.hasData) {
                            int officialIncome = 0;
                            var sum = 0;
                            for (var i = 0;
                                i < snapshot1.data!.docs.length;
                                i++) {
                              var my =
                                  int.parse(snapshot1.data!.docs[i]['amount']);
                              int amountCount = my;
                              sum = amountCount + sum;
                              totalExpense = sum;
                            }

                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("official_account")
                                    .where('email', isEqualTo: user!.email)
                                    .snapshots(),
                                builder: (context, income) {
                                  if (income.hasError) {
                                    return Text("something went wrong");
                                  }
                                  if (income.hasData) {
                                    var myIncomme = int.parse(
                                        income.data!.docs[0]['income']);
                                    int availableIncome = myIncomme;
                                    var getIncome =
                                        income.data!.docs[0]['income'];
                                    return Text(
                                      (availableIncome - totalExpense)
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 40),
                                    );
                                  }
                                  return const Text(
                                    "Calculating",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                });
                          }
                          return const Text(
                            "Loading ...",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Overview Report",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width / 2.3,
                  height: size.height / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 9,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Income",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('official_account')
                                  .where('email', isEqualTo: user!.email)
                                  .snapshots(),
                              builder: (context, incomeSnapshot) {
                                // print(totalIncome);
                                if (incomeSnapshot.hasError) {
                                  return const Text("Something went wrong");
                                }
                                if (incomeSnapshot.hasData) {
                                  return Text(
                                    incomeSnapshot.data!.docs[0]['income']
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                    ),
                                  );
                                }
                                return const Text("Loading .... ");
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const ExpenseScreen();
                    }));
                  }),
                  child: Container(
                    width: size.width / 2.3,
                    height: size.height / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 9,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Expense Table",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("expense")
                                  .snapshots(),
                              builder: (context, snapshot2) {
                                if (snapshot2.hasError) {
                                  return const Text("Something went wrong");
                                }
                                if (snapshot2.hasData) {
                                  var sum = 0;
                                  for (var i = 0;
                                      i < snapshot2.data!.docs.length;
                                      i++) {
                                    var my = int.parse(
                                        snapshot2.data!.docs[i]['amount']);
                                    int amountCount = my;
                                    sum = amountCount + sum;
                                    totalExpense = sum;
                                  }
                                  return Text(
                                    totalExpense.toString(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  );
                                }
                                return Text("Loading");
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Latest Expenses",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const TransactionHistory();
                    }));
                  },
                  child: const Text(
                    "Expense History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // for (var x = 0; x < 5; x++)
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("expense")
                    .limit(3)
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
                            // padding: EdgeInsets.only(bottom: 50),
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return const ExpenseScreen();
                                  }));
                                },
                                child: ListTile(
                                  title: Text(
                                    data['merchant'],
                                  ),
                                  subtitle: Text(
                                    "NGN" + data['amount'],
                                  ),
                                  trailing: Text(
                                    data['date'],
                                  ),
                                  leading: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return ViewFullImage(
                                            image: data['receipt']);
                                      }));
                                    },
                                    child: data['receipt'] == ''
                                        ? CircleAvatar(
                                            child: Icon(Icons.receipt),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              data['receipt'],
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  }
                  return Text("loading ....");
                }),
          ],
        ),
      ),
    );
  }
}
