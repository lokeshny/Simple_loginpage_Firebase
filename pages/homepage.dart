import 'dart:developer' as lokesh;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/pages/viewnote.dart';
import 'package:login_page_firebase_app/widgits/note_cell.dart';

import 'add_note.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Color> myColors = [
    Colors.cyan.shade200,
    Colors.teal.shade200,
    Colors.tealAccent.shade200,
    Colors.pink.shade200,
  ];

  /*CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');*/

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  CollectionReference<Map<String, dynamic>> getQuery() {
    /* lokesh.log(FirebaseAuth.instance.currentUser!.uid);*/
    return FirebaseFirestore.instance
        .collection('users')
        .doc("private")
        .collection('notes');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      endDrawerEnableOpenDragGesture: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => const AddNote(),
          ))
              .then(
            (value) {
              setState(() {});
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            height: 55,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 55,
                  width: 150,
// )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Search your notes',
                            border: InputBorder.none),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<QuerySnapshot>(
            future: getQuery().get(),
            builder: (context, snapshot) {
              lokesh.log("11111111");
              if (snapshot.hasData) {
                lokesh.log("${snapshot.data!.docs.length}");
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("You have no notes"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Random random = Random();
                    Color cl = myColors[random.nextInt(4)];
                    Map? data = snapshot.data?.docs[index].data() as Map;
                    return NoteCell(
                      color: cl,
                      title: data["title"],
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => ViewNote(
                              data: data,
                              ref: snapshot.data!.docs[index].reference),
                        ))
                            .then((value) {
                          setState(() {});
                        });
                      },
                    );
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => ViewNote(
                              data: data,
                              ref: snapshot.data!.docs[index].reference),
                        ))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Card(
                          margin: const EdgeInsets.all(22),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: cl,
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Text(
                                  "${data['title']}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("Loading"),
                );
              }
            },
          ),
        ]),
      ),
      //
    ));
  }
}
