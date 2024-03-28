import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadPaperPage extends StatelessWidget {
  const UploadPaperPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Paper Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Paper'),
        ),
        body: const UploadPaperForm(),
      ),
    );
  }
}

class UploadPaperForm extends StatefulWidget {
  const UploadPaperForm({super.key});
  @override
  _UploadPaperFormState createState() => _UploadPaperFormState();
}

class _UploadPaperFormState extends State<UploadPaperForm> {
  PlatformFile? _pickedFile; // Initialized to null
  TextEditingController _titleController = TextEditingController();
  TextEditingController _topicsController = TextEditingController();

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  void _submitPaper() {
    String title = _titleController.text;
    String topics = _topicsController.text;
    if (_pickedFile != null) {
      print('Title: $title');
      print('Related Topics: $topics');
      print('File Name: ${_pickedFile!.name}');
      print('File Size: ${_pickedFile!.size} bytes');
    } else {
      print('Please select a PDF file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _topicsController,
            decoration: InputDecoration(labelText: 'Related Topics'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Choose PDF'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitPaper,
            child: Text('Submit Paper'),
          ),
          SizedBox(height: 20),
          _pickedFile != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Name: ${_pickedFile!.name}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'File Size: ${_pickedFile!.size} bytes',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
