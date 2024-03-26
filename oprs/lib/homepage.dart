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
    const HomeScreen(),
    const Review(),
    const ReviewPage(),
    const LoginScreen(title: 'Login'),
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
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.favorite), text: 'Submitted Papers'),
              Tab(icon: Icon(Icons.book), text: 'Reviewed Papers'),
              Tab(icon: Icon(Icons.person), text: 'Login/Signup'),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

  @override
  State<LoginScreen> createState() => MyLoginPage();
}

class MyLoginPage extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  void login() {
    print("here");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                style: TextStyle(
                    fontSize: 30, color: Color.fromARGB(255, 98, 98, 98)),
                'Welcome to OPRS'),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 1000.0,
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Username'),
                controller: username,
              ),
            ),
            SizedBox(
              width: 1000.0,
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Password'),
                controller: password,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 236, 236, 236),
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: login,
                  child: const Text('Login'),
                ),
                const SizedBox(
                  width: 50,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 236, 236, 236),
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    username.text = '';
                    password.text = '';
                  },
                  child: const Text('Reset'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
