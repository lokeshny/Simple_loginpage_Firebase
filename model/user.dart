
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String password;
  final String id;


  const User({required this.password, required this.id,required this.email});

  Map<String, dynamic> fromMap() => {
    'email': email,
    'password': password,
    'id':id

  };

  static User fromDocumentsSnapshot(DocumentSnapshot<Object?> doc) {
    return User(
      email: doc["email"],
      password: doc["password"],
      id:doc['id']

    );
  }
}