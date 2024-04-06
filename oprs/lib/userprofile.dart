import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String _name = '';
  List<String> _selectedTopics = [];

  void _updateProfile(String name, List<String> topics) async {
    // Save the profile to Firestore
    //create a user collection in firestore and save the user details including name and topics
    //check if the user id is not null then assign the user id to the uid variable
    String uid = FirebaseAuth.instance.currentUser!.uid;
    //check if user is already stored in users or not and if not then add the user to the users collection
    //else update the user details
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'topics': topics,
    }, SetOptions(merge: true));
    //output updated profile details using snackbar

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("The paper has been submitted successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Select Proficiency Topics:'),
            const SizedBox(height: 10),
            MultiSelectDropDown(
              // showClearIcon: true,
              //controller: _controller,
              onOptionSelected: (options) {
                debugPrint(options.toString());
              },
              options: const <ValueItem>[
                ValueItem(label: 'Algorithms', value: '1'),
                ValueItem(
                    label: 'Artificial Intelligence and Machine Learning',
                    value: '2'),
                ValueItem(
                    label: 'Bioinformatics and Computational Biology',
                    value: '3'),
                ValueItem(
                    label: 'Blockchain Technology and Cryptocurrencies',
                    value: '4'),
                ValueItem(
                    label: 'Cloud Computing and Distributed Systems',
                    value: '5'),
                ValueItem(
                    label: 'Computer Vision and Image Processing', value: '6'),
                ValueItem(
                    label: 'Cybersecurity and Network Security', value: '7'),
                ValueItem(
                    label: 'Data Science and Big Data Analytics', value: '8'),
                ValueItem(
                    label: 'Internet of Things (IoT) and Edge Computing',
                    value: '9'),
                ValueItem(
                    label: 'Natural Language Processing and Text Mining',
                    value: '10'),
                ValueItem(
                    label: 'OQuantum Computing and Quantum Information Science',
                    value: '11'),
                ValueItem(
                    label: 'Robotics and Autonomous Systems', value: '12'),
                ValueItem(label: 'Software Engineering', value: '12'),
              ],
              maxItems: 200,
              disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              searchEnabled: true,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save profile or perform necessary actions
                //create a user collection in firestore and save the user details including name and topics
                //check if none of the fields are empty
                if (_name.isEmpty || _selectedTopics.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text(
                            "Please fill in all the fields before submitting."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
                _updateProfile(_name, _selectedTopics);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
