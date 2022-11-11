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
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();
  static QueryDocumentSnapshot? lastNote;
  static get uid => FirebaseAuth.instance.currentUser?.uid;
  static bool allLNotes = false;
  /*final String id = uuid.v4();*/

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

  Future<List<Note>> initialFetch() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    final snapshot = await ref
        .limit(6)
        .get();
    if (snapshot.docs.isNotEmpty) {
      lastNote = snapshot.docs.last;
    }
    final List<Note> dataFromFb = [];
    final notesList = snapshot.docs.map((document) => Note.fromDocumentsSnapshots(document)).toList();
    /*for (var element in snapshot.docs) {
      final data = element.data();
     *//* final note = Note.fromDocumentsSnapshot(element.data());
      dataFromFb.add(note);*//*
      log(element['title']);
    }*/
    return notesList;
  }

    Future<List<Note>> fetchMoreData() async {
      CollectionReference ref = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("note");
      if (allLNotes == true) {
        return [];
      }
      if (lastNote == null) {
        return [];
      }
      final snapshot = await ref
          .orderBy("title")
          .startAfterDocument(lastNote!)
          .limit(6)
          .get();

      lastNote = snapshot.docs.last;
      final List<Note> dataFromFb = [];
     final notesList = snapshot.docs.map((document) => Note.fromDocumentsSnapshots(document)).toList();

      /*for (var element in snapshot.docs) {
        final data = element.data();
        log(element['title']);
        final note = Note.fromDocumentsSnapshots(element);
        dataFromFb.add(note);
      }*/
      if (snapshot.docs.length < 6) {
        allLNotes = true;
      }
      return notesList;
    }
}
