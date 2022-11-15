import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/main.dart';
import 'package:login_page_firebase_app/model/user.dart';
import 'package:login_page_firebase_app/pages/login_page.dart';
import 'package:login_page_firebase_app/model/user.dart' as lokesh;
import 'package:uuid/uuid.dart';


import '../model/note.dart';
import 'google_auth.dart';

class AuthService {
  AuthService.privateCon();
 static final AuthService instance = AuthService.privateCon();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
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
        final uid = userCredential.user?.uid;
        lokesh.User user = lokesh.User(
          password: password,
          id: uid!,
          email: email);
      await firestore.collection('users').doc(uid).set(user.fromMap());

        return true;
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
