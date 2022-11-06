import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/service/google_auth.dart';

import '../service/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '';
  AuthService service = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Welcome to Note app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "password",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(),
                onPressed: ()  async {
                  final isSucces = await service.signIn(emailController.text,passwordController.text);


                  if(isSucces){
                    Navigator.pushReplacementNamed(context, 'noteHome');
                  }else{
                    //TODO:Show POPUPS
                  }
                  /*if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('snack'),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'ACTION',
                        onPressed: () {},
                      ),
                    ));
                  } else {
                    Navigator.pushReplacementNamed(context, 'noteHome');

                    print("Signed in");
                  }*/

                },
                child: Text("Login")),
          ),
          RichText(
              text: TextSpan(
                  text: "Don\'t have an account?",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 20),
                  children: [
                TextSpan(
                    text: "Creat",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.pushReplacementNamed(context, 'register'))
              ])),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 10),
            child: Row(
              children: [
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.height * 0.15,
                  color: Colors.grey,
                ),
                Text(
                  "or Login with",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.height * 0.14,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.facebook,
                      color: Colors.blue,
                    )),
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                    onPressed: () {
                      signInWithGoogle(context);
                    },
                    icon: Image.asset('image/g.png')),
              ),
            ],
          )
          /*Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
                child: Text("Register")),
          ),*/
        ],
      ),
    );
  }
}
