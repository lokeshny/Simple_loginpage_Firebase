import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/main.dart';
import 'package:login_page_firebase_app/pages/login_page.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
 /* final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();*/
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');


  Future signUp(String email, String password) async {
    {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: email,
                password: password);
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }

   Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password);
      updateLoginStatus(true);
      log("Inside firebase log");
      return true;
    } on FirebaseAuthException catch (e) {
      log("Inside firebase auth");
      return false;
      /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('snack'),
*/ /*duration: const Duration(seconds: 1),*/ /*
        action: SnackBarAction(
          label: 'ACTION',
          onPressed: () {},
        ),
      ));*/
      print(e);
    }
  }
  Future signOut() async {
    await auth.signOut();
    updateLoginStatus(false);
  }
}
