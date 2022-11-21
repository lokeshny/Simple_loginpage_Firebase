import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/pages/reminder_page.dart';

import 'home_page.dart';

class SideBarMenu extends StatelessWidget {
const SideBarMenu({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        const ListTile(
          title: Text(
            'Notes Keep',
            style: TextStyle(fontSize: 25),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text(
            'Notes',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ),
            );
          },
        ),
        ListTile(
            leading: const Icon(Icons.remember_me),
            title: const Text(
              'Remainder',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Remainder(),
                          ));
            }),
        ListTile(
            leading: Icon(Icons.create),
            title: const Text(
              'Profile',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
               /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetail(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            ),
                          ));*/
            }),
        const ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Settings',
            style: TextStyle(fontSize: 20),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.archive),
          title: const Text(
            'Archive',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArchievedNotes(),
                        ));*/
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text(
            'Sign Out',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
        ),
      ],
    ),
  );
}
}