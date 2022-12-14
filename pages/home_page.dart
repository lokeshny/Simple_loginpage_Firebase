import 'dart:developer' as lokesh;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/pages/search_note.dart';
import 'package:login_page_firebase_app/pages/side-menubar.dart';
import 'package:login_page_firebase_app/pages/view_note.dart';
import 'package:login_page_firebase_app/widgits/note_cell.dart';

import '../model/note.dart';
import '../service/firebase_note_service.dart';
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
   List<Note> notesList = [];
  bool isListView = true;
  bool loadding = false;

  initialFetch() async {
    print("intial fetch");
    List<Note> initialNotes = await FirebaseNoteService.instance.initialFetch();
    setState(() {
      notesList = initialNotes;
      loadding = false;
    });
  }

  fetchData() async {
     setState(() {
      loadding = true;
    });
    print("fetch more");
    List<Note> fetchedNotes = await FirebaseNoteService.instance.fetchMoreData();

    setState(() {
      notesList.addAll(fetchedNotes);
      loadding = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initialFetch();
    /*scrollController.addListener(() {
      print("inside listner");
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !loadding) {
        fetchData();

      }
    });*/
    scrollController.addListener(() {
      print("inside listner");
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScrol = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height*0.25;

      if(maxScroll -currentScrol<= delta){
        fetchData();
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
  final GlobalKey<ScaffoldState> _drawKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

      backgroundColor: Colors.white,
      endDrawerEnableOpenDragGesture: true,
          key: _drawKey,
          drawer: const SideBarMenu(),
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
      body: Column(children: [

        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      _drawKey.currentState!.openDrawer();
                    },
                    icon: const Icon(Icons.menu)),
                SizedBox(
                  height: 55,
                  width: 150,

// )),
                  child: GestureDetector(
                    child: Container(
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Search your notes',
                              border: InputBorder.none),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, 'search');
                          }),
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
                            onPressed: () {
                              setState(() {
                                isListView = !isListView;
                              });
                            },
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
        ),
        Expanded(
          flex: 9,
          child: GridView.builder(
           controller: scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isListView ? 1 : 2,crossAxisSpacing: 3,
             /* mainAxisSpacing: 4,*/

            ),
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
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewNote(
                        callbackFunctions: (){
                          initialFetch();
                          lokesh.log('inside callback');
                        },
                        note: note,
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
              );
            }),

        ),

      ]),
    ));
  }
}


