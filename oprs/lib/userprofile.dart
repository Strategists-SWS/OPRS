import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  List<String> _selectedTopics = [];
  final List<String> _allTopics = [
	'Algorithms',
	'Artificial Intelligence and Machine Learning',
	'Bioinformatics and Computational Biology',
	'Blockchain Technology and Cryptocurrencies',
	'Cloud Computing and Distributed Systems',
	'Computer Vision and Image Processing',
	'Cybersecurity and Network Security',
	'Data Science and Big Data Analytics',
	'Internet of Things (IoT) and Edge Computing',
	'Natural Language Processing and Text Mining',
	'Quantum Computing and Quantum Information Science',
	'Robotics and Autonomous Systems',
	'Software Engineering and Programming Languages'
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _nameController.text = userData['name'];
          _selectedTopics = List<String>.from(userData['topics']);
        });
      }
    }
  }

Future<void> _updateProfile() async {
  User? user = _auth.currentUser;
  if (user != null) {
    await _firestore.collection('users').doc(user.uid).set({
      'name': _nameController.text,
      'topics': _selectedTopics,
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
	return AlertDialog(
	  title: Text('Success'),
	  content: Text('Profile updated successfully.'),
	  actions: <Widget>[
	    TextButton(
	      onPressed: () {
	        Navigator.of(context).pop();
	      },
	      child: Text('OK'),
	    ),
	  ],
	);
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Select Topics'),
              Expanded(
                child: ListView(
                  children: _allTopics.map((topic) {
                    return CheckboxListTile(
                      title: Text(topic),
                      value: _selectedTopics.contains(topic),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedTopics.add(topic);
                          } else {
                            _selectedTopics.remove(topic);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfilePage(),
  ));
}

