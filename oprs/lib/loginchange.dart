import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginChangeNotifier extends ChangeNotifier {
  LoginChangeNotifier() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _isAdmin = (user.email == 'harshitiitkgp@kgpian.iitkgp.ac.in');
      } else {
        _loggedIn = false;
        _isAdmin = false;
      }
      notifyListeners();
    });
  }
}