import 'package:employee_expense_management/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? email;

  String? password;
  bool obscure = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "LOGIN ",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                onSaved: (e) {
                  email = e;
                },
                onChanged: (e) {
                  email = e;
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.email(context),
                ]),
                decoration: InputDecoration(
                  prefix: const Icon(
                    Icons.email,
                  ),
                  label: const Text("Email Address"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                obscureText: obscure,
                onSaved: (e) {
                  password = e;
                },
                onChanged: (e) {
                  password = e;
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.min(context, 5),
                ]),
                decoration: InputDecoration(
                  label: const Text("Password"),
                  prefix: const Icon(Icons.vpn_key),
                  suffix: obscure
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          child: const Icon(Icons.visibility_off))
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          child: const Icon(Icons.visibility)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Material(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: () {
                    handleSignin(email.toString(), password.toString());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
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

  handleSignin(String email, String password) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return const Home();
        }));
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 10),
          content: Text(e.message),
          action: SnackBarAction(label: "Retry", onPressed: () {}),
        ));
      });
    }
  }
}
