import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/homepage.dart';
import 'package:oprs/public.dart';
import 'package:oprs/adminhome.dart';

bool isAdmin(String email) {
  if (email == 'admin@gmail.com') {
    return true;
  } else {
    return false;
  }
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key});

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
    return Builder(
      builder: (context) {
        return MaterialApp(
          home: FlutterLogin(
            logo: 'assets/logo.png',
            onLogin: tryLogin,
            onSignup: trySignUp,
            onSubmitAnimationCompleted: () {
              if (isAdmin(FirebaseAuth.instance.currentUser!.email!)) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const AdminPage(),
                ));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ));
              }
            },
            onRecoverPassword: (_) async {
              return null;
            },
            theme: LoginTheme(
              primaryColor: Color.fromARGB(
                  255, 69, 67, 67), // Keep the primary color black
              buttonTheme: LoginButtonTheme(
                splashColor:
                    Color.fromARGB(255, 108, 101, 245), // Keep the splash color
                backgroundColor: Colors.deepPurple[
                    400], // Set the background color of the button to purple
              ),
              textFieldStyle: TextStyle(
                color: Color.fromARGB(
                    255, 132, 77, 233), // Keep the text field color
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key});
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
