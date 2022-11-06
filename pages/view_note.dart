import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  final DocumentReference ref;

  const ViewNote({super.key, required this.data, required this.ref});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  String? title;
  String? des;

  bool edit = true;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['contents'];
    return Scaffold(
        appBar: AppBar(actions: [
          ElevatedButton(
              onPressed: () {
                edit = !edit;
              },
              child: const Icon(Icons.edit)),
          ElevatedButton(
              onPressed: () {

                save();
              },
              child: const Icon(Icons.save_rounded)),
          ElevatedButton(
              onPressed: () {
                {
                  delete();
                }
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

  void delete() async {
    await widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    if (key.currentState!.validate()) {
      await widget.ref.update(
        {'title': title, 'note': des},
      );
      Navigator.of(context).pop();
    }
  }
}
