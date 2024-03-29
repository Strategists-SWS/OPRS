import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/homepage.dart';
import 'package:oprs/public.dart';

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
          builder: (context) => const MyHomePage(),
        ));
      },
      onRecoverPassword: (_) async {
        return null;
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any loading indicator
        }

        if (snapshot.hasData) {
          String userId = snapshot.data!.uid;
          return SubmitPage(userId: userId);
        } else {
          return const MyLoginPage(); // Navigate to your sign in screen if the user is not logged in
        }
      },
    );
  }
}
