import 'package:flutter/material.dart';
import 'user.dart' as ud;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 53, 254, 35)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Online Peer Review System'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final username = TextEditingController();
  final password = TextEditingController();

  void login(){
    for(int i=0;i<ud.users.length;i++)
    {
      if(ud.users[i].username!=username.text)
      print('Username Mismatch');
      else if(ud.users[i].password!=password.text)
      print('Password Mismatch');
      else
      print('Match');
    }
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
              style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 98, 98, 98)),
              'Welcome to OPRS'
            ),
            const SizedBox(
                height: 50,
            ),
            SizedBox(
            width: 1000.0,
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Username'
              ),
              controller: username,
            ),
          ),
          SizedBox(
            width: 1000.0,
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password'
              ),
              controller: password,
              obscureText: true,
            ),
          ),
          const SizedBox(
            height: 10
          ),
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
                  onPressed: () {},
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
