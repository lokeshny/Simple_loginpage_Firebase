import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/note.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String? title;
  String? description;

   void add() async {
     CollectionReference ref = FirebaseFirestore.instance
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
     /*Navigator.of(context).pop();*/
     Navigator.pop(context);
   }


   @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Icon(Icons.arrow_back)),
                ElevatedButton(
                    onPressed: add,

                    child: Text("Save"))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration.collapsed(
                    hintText: "Title",
                  ),
                  style: const TextStyle(
                    fontSize: 32.0,
                  ),
                  onChanged: (val) {
                    title = val;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    decoration: const InputDecoration.collapsed(
                      hintText: " Note Description",
                    ),
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (val) {
                     description = val;
                    },
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    ));
  }
}

