import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadPaperPage extends StatelessWidget {
  const UploadPaperPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Paper'),
      ),
      body: const UploadPaperForm(),
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();
  bool _isUploading = false;

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

  void _submitPaper(BuildContext pcontext) async {
    String title = _titleController.text;
    String topics = _topicsController.text;
    DateTime submissionDate = DateTime.now();
    if (title.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Title can't be empty"),
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
    } else if (topics.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Related topics can't be empty"),
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
    } else {
      if (_pickedFile != null) {
        setState(() {
          _isUploading = true;
        });
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('pdfs/${submissionDate.millisecondsSinceEpoch}.pdf');
        UploadTask uploadTask = storageReference.putData(_pickedFile!.bytes!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String pdfUrl = await taskSnapshot.ref.getDownloadURL();
        String adminId = 'iSksdEGbE8QLLLLLYKg9TP0cYrO2';
        // Store paper details in Firestore
        await FirebaseFirestore.instance.collection('papers').add({
          'userId': user.uid,
          'title': title,
          'relatedTopics': topics,
          'url': pdfUrl,
          'submissionDate': submissionDate,
          'assignedTo': adminId,
        });
        // Show success message and return to the Review widget
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
                    Navigator.pop(pcontext);
                    setState(() {
                      _isUploading = false;
                    });
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Please select a PDF"),
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
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _topicsController,
            decoration: const InputDecoration(labelText: 'Related Topics'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickFile,
            child: const Text('Choose PDF'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (!_isUploading) _submitPaper(context);
            },
            child: const Text('Submit Paper'),
          ),
          const SizedBox(height: 20),
          _pickedFile != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Name: ${_pickedFile!.name}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'File Size: ${_pickedFile!.size} bytes',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
