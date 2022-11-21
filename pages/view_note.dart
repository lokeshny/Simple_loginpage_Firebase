import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/pages/reminder_page.dart';

import '../model/note.dart';
import '../service/firebase_note_service.dart';

class ViewNote extends StatefulWidget {
 /* final Map data;
  final DocumentReference ref;*/

  final Note note;
  final Function() callbackFunctions;

  const ViewNote({super.key, required this.note, required this.callbackFunctions});



  /*const ViewNote({super.key, required this.data, required this.ref});*/


  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  String? title;
  String? des;

  bool edit = true;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.note.title;
    des = widget.note.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          ElevatedButton(
              onPressed: () {

              },
              child: const Icon(Icons.edit)),
          ElevatedButton(
              onPressed: () {
                widget.note.title = title;
                FirebaseNoteService.instance.updateNote(widget.note);
                widget.callbackFunctions();
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.save_rounded)),
          ElevatedButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Remainder(),
                ));
          }, child: Icon(Icons.notifications)),
          ElevatedButton(
              onPressed: () {
                FirebaseNoteService.instance.deleteNote(widget.note.id);
                Navigator.pop(context);
              },
              child: const Icon(Icons.delete))
        ]),
        body: Form(
          key: key,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Title'),
              initialValue: title,
              enabled: edit,
              onChanged: (val) {
                title = val;
              },
              validator: (val) {
                if (val!.isEmpty) {
                  return "Can't be empty !";
                } else {
                  return null;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
              ),
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'Notes'),
                initialValue: des,
                style: const TextStyle(fontSize: 17, color: Colors.cyan),
                enabled: edit,
                onChanged: (val) {
                  des = val;
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Can't be empty !";
                  } else {
                    return null;
                  }
                },
              ),
            )
          ]),
        ));
  }

}
