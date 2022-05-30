import 'package:employee_expense_management/screens/home.dart';
import 'package:employee_expense_management/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;

    runApp(MyApp(user: user,));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, required this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //   // SystemUiOverlay.bottom,
    // ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // systemNavigationBarColor: Colors.deepPurple, // navigation bar color
      statusBarColor: Color.fromARGB(255, 36, 21, 63), // status bar color
    ));

    return MaterialApp(
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('fa', ''),
        Locale('fr', ''),
        Locale('ja', ''),
        Locale('pt', ''),
        Locale('sk', ''),
        Locale('pl', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Employee Expense',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        secondaryHeaderColor: Colors.deepPurpleAccent,
        primaryColor: Colors.deepPurple,
      ),
      home: user == null ?const LoginScreen():const Home(),
      builder: EasyLoading.init(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
//     //   // SystemUiOverlay.bottom,
//     // ]);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       // systemNavigationBarColor: Colors.deepPurple, // navigation bar color
//       statusBarColor: Color.fromARGB(255, 36, 21, 63), // status bar color
//     ));

//     return MaterialApp(
//       localizationsDelegates: const [
//         FormBuilderLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en', ''),
//         Locale('es', ''),
//         Locale('fa', ''),
//         Locale('fr', ''),
//         Locale('ja', ''),
//         Locale('pt', ''),
//         Locale('sk', ''),
//         Locale('pl', ''),
//       ],
//       debugShowCheckedModeBanner: false,
//       title: 'Employee Expense',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         secondaryHeaderColor: Colors.deepPurpleAccent,
//         primaryColor: Colors.deepPurple,
//       ),
//       home: const Home(),
//       builder: EasyLoading.init(),
//     );
//   }
// }
