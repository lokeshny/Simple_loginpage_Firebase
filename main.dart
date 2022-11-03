import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/rigister_page.dart';
import 'home_screen.dart';
import 'login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute:'first' ,
        routes: {
          'first' :(context) =>LoginPage(),
          'home' :(context) =>HomeScreen(),
          'register' : (context) =>RegisterPage(),
        }
    );
  }
}


