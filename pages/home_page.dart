import 'dart:developer' as lokesh;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/pages/search_note.dart';
import 'package:login_page_firebase_app/pages/view_note.dart';
import 'package:login_page_firebase_app/widgits/note_cell.dart';

import '../model/note.dart';
import '../service/firebase_service.dart';
import '../service/google_auth.dart';
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


  ScrollController scrollController = ScrollController();
  final List<Note> notesList = [];
  bool loadding = false;

  initialFetch() async {
    List<Note> data2 = await AuthService.instance.initialFetch();
    setState(() {
      notesList.addAll(data2);
      loadding = false;
    });
  }

  fetchData() async {
    setState(() {
      loadding = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<Note> data2 = await AuthService.instance.fetchMoreData();

    setState(() {
      notesList.addAll(data2);
      loadding = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initialFetch();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent &&
          !loadding) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
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
                  child: GestureDetector(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                              decoration: InputDecoration(
                                  hintText: 'Search your notes',
                                  border: InputBorder.none),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, 'search');
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.grid_view_outlined,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              AuthService.instance.signOut();
                              Navigator.pushReplacementNamed(context, 'login');
                              print("Signed out");
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: 25,
                            )),
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
            Container(
              child: GridView.builder  (
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                primary: false,
                shrinkWrap: true,
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  final Note note = notesList[index];
                  Random random = Random();
                  Color cl = myColors[random.nextInt(4)];

                  return NoteCell(
                    color: cl,
                    note: note,
                    onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => ViewNote(note: note,
                           ),
                      ));
                    } /*{
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => ViewNote(
                            data: data,
                            ref: snapshot.data!.docs[index].reference),
                      ))
                          .then((value) {
                        setState(() {});
                      });
                    },*/
                  );}),
    ),

        ]),
      ),

    ));
  }
}
