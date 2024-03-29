import 'package:flutter/material.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';


class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String _name = '';
  List<String> _selectedTopics = [];

  final List<String> _proficiencyTopics = [
    'Topic 1',
    'Topic 2',
    'Topic 3',
    // Add more topics as needed
  ];

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
                ValueItem(label: 'Option 1', value: '1'),
                ValueItem(label: 'Option 2', value: '2'),
                ValueItem(label: 'Option 3', value: '3'),
                ValueItem(label: 'Option 4', value: '4'),
                ValueItem(label: 'Option 5', value: '5'),
                ValueItem(label: 'Option 6', value: '6'),
                  ValueItem(label: 'Option 7', value: '7'),
                   ValueItem(label: 'Option 8', value: '8'),
                    ValueItem(label: 'Option 9', value: '9'),
                     ValueItem(label: 'Option 10', value: '10'),
                      ValueItem(label: 'Option 11', value: '11'),
                       ValueItem(label: 'Option 12', value: '12'),
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
