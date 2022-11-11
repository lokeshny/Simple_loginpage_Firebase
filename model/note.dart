import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String  id;
  String? title;
  String? description;


  Note({required this.id, this.title, this.description});

  static  Note fromDocumentsSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Note(id: "id",title: e['title'],description: e['description']);
  }

   static Note fromMap(Map map) {
    return Note(id: "id",title: map['title'],description: map['description']);
  }
}