
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'note.dart';

class SearchNote extends StatefulWidget {
  const SearchNote({Key? key}) : super(key: key);

  @override
  State<SearchNote> createState() => _SearchNoteState();
}

class _SearchNoteState extends State<SearchNote> {

  String searchTitle = ' ';

  List<Note> notes = [];
  List<Note> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  fetchNotes() async {
    final notesDocuments = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes')
        .get();

    notes =
        notesDocuments.docs.map((e) => Note.fromDocumentsSnapshot(e)).toList();
  }

  initSearchingNotes(String textEntered) {
    filteredList =
        notes.where((note) => note.title!.contains(textEntered)).toList();

    setState(() {});
  }

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  @override
  Widget build(BuildContext context) {
      return  Scaffold(
        appBar: AppBar(

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'noteHome');
            },
          ),
          title: TextField(
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    // initSearchingNotes(searchTitle);
                  },
                  icon: const Icon(Icons.search),
                ),
                hintText: 'Search...'),
            onChanged: (textEntered) {
              initSearchingNotes(textEntered);
              // setState(() {
              //   searchTitle = textEntered;
              // });
            },
          ),
        ),
        body: ListView.builder(
            itemBuilder: (context, index) {
              final note = filteredList[index];
              return Card(
                  margin: const EdgeInsets.all(22),
                  shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  // color: bg,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Text(
                          note.title ?? " ",
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ));
            },
            itemCount: filteredList.length),
        // body: FutureBuilder<QuerySnapshot>(
        //   future: postDocumentLists?.whenComplete(() => () {
        //         postDocumentLists;
        //       }),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       if (snapshot.data!.docs.isEmpty) {
        //         return const Center(
        //           child: Text("You have no notes"),
        //         );
        //       }
        //       return ListView.builder(
        //         shrinkWrap: true,
        //         itemCount: snapshot.data?.docs.length,
        //         itemBuilder: (context, index) {
        //           Map? data = snapshot.data?.docs[index].data() as Map;
        //
        //           return Card(
        //               margin: const EdgeInsets.all(22),
        //               shape: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(12)),
        //               // color: bg,
        //               child: Padding(
        //                 padding: const EdgeInsets.all(40.0),
        //                 child: Column(
        //                   children: [
        //                     Text(
        //                       data['title'],
        //                       style: const TextStyle(
        //                         fontSize: 24.0,
        //                         fontWeight: FontWeight.normal,
        //                         color: Colors.black87,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ));
        //         },
        //       );
        //     } else {
        //       return const Center(
        //         child: Text("Loading"),
        //       );
        //     }
        //   },
        // ),
      );
    }
  }
