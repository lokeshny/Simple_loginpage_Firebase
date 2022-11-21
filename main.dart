import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:login_page_firebase_app/pages/rigister_page.dart';
import 'package:login_page_firebase_app/pages/search_note.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/home_screen.dart';
import 'pages/login_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponce) {
  log('inside onDidReceiveBackgroundNotificationResponse');
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
      onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: (notificationResponce) {
        if (notificationResponce != null)
          log('onDidReceiveNotificationResponse');
      });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 final isLoggedIn = await getLoginState();
 print(isLoggedIn);
  runApp( MyApp(isLoggedIn: isLoggedIn,));

}

Future<bool> getLoginState() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isLoggedIn = pref.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

updateLoginStatus(bool logginStatus) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
   pref.setBool('isLoggedIn',logginStatus) ;
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isLoggedIn ? 'noteHome' : "login",
        routes: {
          'login' :(context) =>LoginPage(),
          'home' :(context) =>HomeScreen(),
          'register' : (context) =>RegisterPage(),
          'noteHome' : (context) =>Homepage(),
          'search' : (context) =>SearchNote(),



        }
    );
  }
}


