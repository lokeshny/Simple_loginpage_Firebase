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

  static addNote(String title, String description) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');

    final String id = Uuid().v4();

    var data = {'title': title, 'contents': description, 'id': id};
    ref.add(data);
  }

  void updateNote(Note note) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    ref.doc(note.id!).update({
      /*'id': note.id,*/
      'title': note.title,
      'content': note.description,
    });
  }

  void deleteNote(Note note) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    ref.doc(note.id!).delete();
    print('Inside delet');
  }

  Future<List<Note>> initialFetch() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("notes");
    final snapshot = await ref.limit(10).get();
    if (snapshot.docs.isNotEmpty) {
      lastNote = snapshot.docs.last;
    }
    /*final List<Note> dataFromFb = [];*/
    final notesList = snapshot.docs
        .map((document) => Note.fromDocumentsSnapshots(document))
        .toList();
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
        await ref.orderBy("title").startAfterDocument(lastNote!).limit(10).get();

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
    if (snapshot.docs.length < 10) {
      allLNotes = true;
    }
    return notesList;
  }
}
