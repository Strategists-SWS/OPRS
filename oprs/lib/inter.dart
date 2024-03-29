import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/homepage.dart';
import 'package:oprs/sign_in.dart';

class Intermediate extends StatelessWidget {
  const Intermediate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any loading indicator
        }

        if (snapshot.hasData) {
          if (snapshot.data!.email == 'admin@gmail.com') {
            return const Intermediate();
          } else {
            return const MyHomePage();
          }
        } else {
          return const MyLoginPage(); // Navigate to your sign in screen if the user is not logged in
        }
      },
    );
  }
}
