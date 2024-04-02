import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';


class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String _name = '';
  List<String> _selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Select Proficiency Topics:'),
            SizedBox(height: 10),
            MultiSelectDropDown(
             // showClearIcon: true,
              //controller: _controller,
              onOptionSelected: (options) {
                debugPrint(options.toString());
              },
              options: const <ValueItem>[
                ValueItem(label: 'Algorithms', value: '1'),
                ValueItem(label: 'Artificial Intelligence and Machine Learning', value: '2'),
                ValueItem(label: 'Bioinformatics and Computational Biology', value: '3'),
                ValueItem(label: 'Blockchain Technology and Cryptocurrencies', value: '4'),
                ValueItem(label: 'Cloud Computing and Distributed Systems', value: '5'),
                ValueItem(label: 'Computer Vision and Image Processing', value: '6'),
                ValueItem(label: 'Cybersecurity and Network Security', value: '7'),
                ValueItem(label: 'Data Science and Big Data Analytics', value: '8'),
                ValueItem(label: 'Internet of Things (IoT) and Edge Computing', value: '9'),
                ValueItem(label: 'Natural Language Processing and Text Mining', value: '10'),
                ValueItem(label: 'OQuantum Computing and Quantum Information Science', value: '11'),
                ValueItem(label: 'Robotics and Autonomous Systems', value: '12'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save profile or perform necessary actions
                print('Name: $_name');
                print('Selected Topics: $_selectedTopics');
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
