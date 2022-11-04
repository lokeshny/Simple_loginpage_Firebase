import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              style: ButtonStyle(

              ),
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                    Navigator.pushNamed(context, 'noteHome');
                  } on FirebaseAuthException catch (e) {
                    print(e);
                  }
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
                          ..onTap = () =>   Navigator.pushReplacementNamed(context, 'register'))
                  ])),
          SizedBox(
            height: 20,
          ),
          Padding (
            padding: const EdgeInsets.only(left: 40,right: 10),
            child: Row(
              children: [
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.height*0.15,
                  color: Colors.grey,
                ),
                Text("or Login with",
                style: TextStyle(fontSize: 20,
                color: Colors.grey),),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.height*0.14,
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
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(onPressed:(){}, icon: Icon(Icons.facebook,
                color: Colors.blue,)),
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(onPressed: (){}, icon: Image.asset('image/g.png')),
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
