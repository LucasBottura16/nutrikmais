import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Login Screen"),
      ),
      body: TextButton(
          onPressed: (){
            FirebaseFirestore .instance.collection("users").add({
              "name": "John senaa",
              "email": ""
            });
          },
          child: Text("Text lofin")),
    );
  }
}
