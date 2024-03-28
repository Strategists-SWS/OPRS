import 'package:flutter/material.dart';
import 'package:oprs/public.dart';
import 'package:oprs/reviewer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _currentIndex = 0;

  final List<Widget> _tabs = [
    const Review(),
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
              Tab(icon: Icon(Icons.favorite), text: 'Submitted Papers'),
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
