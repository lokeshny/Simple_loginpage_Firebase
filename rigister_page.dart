import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = '', password = '';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              email = value;
            },
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
        ),
        TextField(
          onChanged: (value) {
            password = value;
          },
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "password",
          ),
        ),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                    Navigator.pushNamed(context, 'home');
                  } on FirebaseAuthException catch (e) {
                    print(e);
                  }
                }
              },
              child: Text("Register")),
        ),
      ]),
    );
  }
}
