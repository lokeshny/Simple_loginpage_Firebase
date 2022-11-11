import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("welcome to home screen"),
          Center(
            child: ElevatedButton(
                onPressed: ()  {
                  dynamic result =  AuthService.instance.signOut();
                  if (result == null) {
                  } else {
                    Navigator.pushReplacementNamed(context, 'login');
                    print("Signed out");
                  }
                },
                child: const Text("Logout")),
          )
        ],
      ),
    );
  }
}
