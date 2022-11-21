import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String  id;
  String? title;
  String? description;
  Timestamp? createdAt ;
/*  DateTime? createdAt ;*/



  Note({required this.id, this.title, this.description,this.createdAt});

  static  Note fromDocumentsSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Note(id: e['id'],
        title: e['title'],
        description: e['content'],
        createdAt: e['createdAt']


    );
  }

   static Note fromMap(Map map) {
    return Note(
        id:  map['id'],
        title: map['title'],
        description: map['content'],
        createdAt: map['createdAt']);
  }

  static Note fromDocumentsSnapshots(QueryDocumentSnapshot<Object?> element) {
    return Note(
      /*id: element.data().toString().contains('id') ? element.get('id') : '',
        title: element.data().toString().contains("title") ? element.get('title'): ' ',
        description: element.data().toString().contains("description") ? element.get('description'): ' ',
      createdAt: element.data().toString().contains("createdAt") ? element.get('createdAt'): ' ',*/
        id: element['id'],
        title: element['title'],
        description: element['content'],
        createdAt: element['createdAt'],
       /* createdAt: DateTime.parse(element["createdAt"]),*/
    );

  }
}