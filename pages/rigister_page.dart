import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page_firebase_app/service/firebase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
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
                dynamic result = await AuthService.instance.signUp(emailController.text,passwordController.text);
                if (result == null) {
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
                }
              },
              child: Text("Register")),
        ),
      ]),
    );
  }
}
