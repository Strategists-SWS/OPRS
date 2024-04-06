import 'package:flutter/material.dart';
import 'package:oprs/reviewer.dart';
import 'package:oprs/sign_in.dart';
import 'package:oprs/assignedpapers.dart';
import 'package:oprs/userprofile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _currentIndex = 0;

  final List<Widget> _tabs = [
    const AuthenticationWrapper(),
    const Abc(),
    const ReviewPage(),
    const Update(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Online Peer Review System'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Perform logout actions here
                // For now, let's just navigate to the login page
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MyLoginPage(),
                ));
              },
            ),
          ],
          shadowColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Submitted Papers'),
              Tab(icon: Icon(Icons.star), text: 'Assigned Papers'),
              Tab(icon: Icon(Icons.book), text: 'Reviewed Papers'),
              Tab(icon: Icon(Icons.person), text: 'Update Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}
