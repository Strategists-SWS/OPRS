import 'package:flutter/material.dart';
import 'package:oprs/reviewer.dart';
import 'package:oprs/sign_in.dart';
import 'package:oprs/assignedpapers.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  //int _currentIndex = 0;

  final List<Widget> _tabs = [
    
    const ReviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Online Peer Review System'),
          shadowColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: 'Papers to Assign'),
              Tab(icon: Icon(Icons.book), text: 'Reviewed Papers'),
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
