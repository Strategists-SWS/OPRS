import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/landing.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  Future<String?> tryLogin(LoginData data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> trySignUp(SignupData data) async {
    if (data.name == null || data.password == null) return 'error';
    String name = data.name as String;
    String password = data.password as String;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: name, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: 'OPRS',
        onLogin: tryLogin,
        onSignup: trySignUp,
        onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
          },
          onRecoverPassword: (_) async {
            return null;
          },
        );
  }
}
