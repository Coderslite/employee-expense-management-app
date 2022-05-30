import 'package:employee_expense_management/screens/home_screen.dart';
import 'package:employee_expense_management/screens/profile.dart';
import 'package:employee_expense_management/screens/transaction.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    const HomeScreen(),
    const ProfileScreen(),
    // const Center(child: Text("1")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const TransactionScreen();
          }));
        },
        child: const Icon(Icons.add_to_queue_outlined),
      ),
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        showElevation: false, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
          ),
          // FlashyTabBarItem(
          //   icon: const Icon(Icons.list),
          //   title: const Text(''),
          // ),
          FlashyTabBarItem(
            icon: const Icon(CupertinoIcons.profile_circled),
            title: const Text('Profile'),
          ),
          // FlashyTabBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('Settings'),
          // ),
          // FlashyTabBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('한국어'),
          // ),
        ],
      ),
      body: tabItems[_selectedIndex],
    );
  }
}
