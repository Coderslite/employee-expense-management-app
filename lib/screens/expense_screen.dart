import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_expense_management/screens/transaction_edit.dart';
import 'package:employee_expense_management/screens/view_full_imgae.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  @override
  void initState() {
    user.initData(100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 100,
        left: 20,
        right: 20,
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("expense").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.hasData) {
              return HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 800,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: snapshot.data!.docs.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                verticalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.yellow,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.red,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                enablePullToRefresh: true,
                refreshIndicator: const WaterDropHeader(),
                refreshIndicatorHeight: 60,
                onRefresh: () async {
                  //Do sth
                  await Future.delayed(const Duration(milliseconds: 500));
                  _hdtRefreshController.refreshCompleted();
                },
                enablePullToLoadNewData: true,
                loadIndicator: const ClassicFooter(),
                onLoad: () async {
                  //Do sth
                  await Future.delayed(const Duration(milliseconds: 500));
                  _hdtRefreshController.loadComplete();
                },
                htdRefreshController: _hdtRefreshController,
              );
            }
            return const Text("Loading .....");
          }),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Date' + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
            100),
        onPressed: () {
          sortType = sortName;
          isAscending = !isAscending;
          user.sortName(isAscending);
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Merchant' +
                (sortType == sortStatus ? (isAscending ? '↓' : '↑') : ''),
            100),
        onPressed: () {
          sortType = sortStatus;
          isAscending = !isAscending;
          // user.sortStatus(isAscending);
          setState(() {});
        },
      ),
      _getTitleItemWidget('Total', 120),
      _getTitleItemWidget('Status', 100),
      _getTitleItemWidget('Comment', 300),
      _getTitleItemWidget('view image', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('expense').snapshots(),
        builder: (context, dateSnapshot) {
          if (dateSnapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (dateSnapshot.hasData) {
            return Container(
              child: Text(dateSnapshot.data!.docs[index]['date']),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            );
          }
          return const Text("Loading..");
        });
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('expense').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData) {
            if (snapshot.data!.docs == null ||
                snapshot.data!.size == 0 ||
                snapshot.data!.docs.isEmpty) {
              return Text("no data found");
            }
            var data = snapshot.data!.docs[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return TransactionEditScreen(
                    amount: data['amount'],
                    merchant: data['merchant'],
                    note: data['note'],
                    date: data['date'],
                    receiptUrl: data['receipt'],
                    receiptExt: data['receiptExt'],
                    docID: data.id,
                  );
                }));
              },
              child: Row(
                children: [
                  Container(
                    child: Row(
                      children: <Widget>[
                        // Icon(
                        //     user.userInfo[index].merchant
                        //         ? Icons.notifications_off
                        //         : Icons.notifications_active,
                        //     color:
                        //         user.userInfo[index].merchant ? Colors.red : Colors.green),
                        Text(data['merchant'])
                      ],
                    ),
                    width: 100,
                    height: 52,
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(
                      "NGN " + (data['amount']),
                    ),
                    width: 120,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text('Reimbursed'),
                    width: 100,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(data['note']),
                    width: 300,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: data['receipt'] == ''
                        ? GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                duration: Duration(seconds: 4),
                                content: Text("No Receipt Available "),
                              ));
                            },
                            child: const Text("No Receipt Available"))
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ViewFullImage(image: data['receipt']);
                              }));
                            },
                            child: Image.network(data['receipt'])),
                    width: 100,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            );
          }
          return const Text("Loading ......");
        });
  }
}

User user = User();

class User {
  List<UserInfo> userInfo = [];

  void initData(int size) {
    for (int i = 0; i < size; i++) {
      userInfo.add(UserInfo('05/27/2022', 'Rental Cars', '+001 9999 9999',
          '2019-01-01', 'Expense from my business trip.'));
    }
  }

  ///
  /// Single sort, sort Name's id
  void sortName(bool isAscending) {
    userInfo.sort((a, b) {
      int aId = int.tryParse(a.date.replaceFirst('User_', '')) ?? 0;
      int bId = int.tryParse(b.date.replaceFirst('User_', '')) ?? 0;
      return (aId - bId) * (isAscending ? 1 : -1);
    });
  }

  ///
  /// sort with Status and Name as the 2nd Sort
}

class UserInfo {
  String date;
  String merchant;
  String phone;
  String registerDate;
  String terminationDate;

  UserInfo(this.date, this.merchant, this.phone, this.registerDate,
      this.terminationDate);
}
