import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String  id;
  String? title;
  String? description;


  Note({required this.id, this.title, this.description});

  static  Note fromDocumentsSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Note(id: e['id'],title: e['title'],description: e['contents']);
  }

   static Note fromMap(Map map) {
    return Note(id:  map['id'],title: map['title'],description: map['contents']);
  }

  static Note fromDocumentsSnapshots(QueryDocumentSnapshot<Object?> element) {
    return Note(id: element['id'],title: element['title'],description: element['contents']);

  }
}