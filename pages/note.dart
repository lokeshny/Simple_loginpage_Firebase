import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? title;
  String? description;

  Note(this.title, this.description);

  static  Note fromDocumentsSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Note(e['title'], e['contents']);
  }
}