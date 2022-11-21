

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../model/note.dart';

class FirebaseNoteService {
  FirebaseNoteService.privateCon();

  static final FirebaseNoteService instance = FirebaseNoteService.privateCon();
  Note? note;
  static const uuid = Uuid();
  static QueryDocumentSnapshot? lastNote;

  static get uid => FirebaseAuth.instance.currentUser?.uid;
  static bool allLNotes = false;

  static addNote(String title, String description, DateTime createdAt) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');

    createdAt = DateTime.now();

    final String id = Uuid().v4();
    DocumentReference document = ref.doc();
    await ref.doc(document.id).set({
      'id': document.id,
      'title': title,
      'content': description,
      'createdAt': createdAt,
    });
    return document.id;

    var data = {'title': title,
      'contents': description,
      'id': id};
    ref.add(data);
  }

  Future<void> updateNote(Note note) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    final  snapshot = await ref.where('id',isEqualTo: note.id).get();
    for(var doc in snapshot.docs){
      log('inside snopshots');
      doc.reference.update({
        'title': note.title,
        'content': note.description,
        'createdAt':note.createdAt,
      });
    }
    /*ref.doc(note.id!).update({
      *//*'id': note.id,*//*
      'title': note.title,
      'content': note.description,
    });*/
  }

  Future<void> deleteNote(String id) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    final  snapshot = await ref.where('id',isEqualTo:id).get();
    for(var doc in snapshot.docs){
      log('inside snopshots');
      await doc.reference.delete();
    }
    /*ref.doc(note.id!).delete();*/
    print(id);
  }

  Future<List<Note>> initialFetch() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    final snapshot = await ref.limit(6).get();
    if (snapshot.docs.isNotEmpty) {
      lastNote = snapshot.docs.last;
    }
    /*final List<Note> dataFromFb = [];*/
    final notesList = snapshot.docs
        .map((document) => Note.fromDocumentsSnapshots(document))
        .toList();
    if (snapshot.docs.length < 6) {
      allLNotes = true;
    }
    return notesList;
    /*for (var element in snapshot.docs) {
      final data = element.data();
     */ /* final note = Note.fromDocumentsSnapshot(element.data());
      dataFromFb.add(note);*/ /*
      log(element['title']);
    }*/
    return notesList;
  }

  Future<List<Note>> fetchMoreData() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("note");
    if (allLNotes == true) {
      return [];
    }
    if (lastNote == null) {
      return [];
    }
    final snapshot =
        await ref.orderBy("title").startAfterDocument(lastNote!).limit(6).get();

    lastNote = snapshot.docs.last;

    final notesList = snapshot.docs
        .map((document) => Note.fromDocumentsSnapshots(document))
        .toList();

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
