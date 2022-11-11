import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseNoteService{
  static addNote(String title, String description)  {
    CollectionReference ref =  FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');

    final String id = Uuid().v4();

    var data = {
      'title': title,
      'contents': description,
      'id':id
    };
    ref.add(data);
  }
  static deletNote(){

  }

  static updateNote(){

  }
}