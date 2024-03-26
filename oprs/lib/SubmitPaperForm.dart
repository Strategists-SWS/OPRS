import 'package:flutter/material.dart';

class SubmitPaperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submit Paper Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Submit Paper for Review'),
        ),
        body: SubmitPaperForm(),
      ),
    );
  }
}

class SubmitPaperForm extends StatefulWidget {
  @override
  _SubmitPaperFormState createState() => _SubmitPaperFormState();
}

class _SubmitPaperFormState extends State<SubmitPaperForm> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _abstractController = TextEditingController();
  TextEditingController _topicsController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Paper Title',
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _abstractController,
            decoration: InputDecoration(
              labelText: 'Abstract',
            ),
            maxLines: 5,
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _topicsController,
            decoration: InputDecoration(
              labelText: 'Topics',
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _linkController,
            decoration: InputDecoration(
              labelText: 'Link to Research Paper',
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Submit paper logic goes here
              String title = _titleController.text;
              String abstract = _abstractController.text;
              String topics = _topicsController.text;
              String link = _linkController.text;

              // Placeholder for submission logic
              print('Title: $title');
              print('Abstract: $abstract');
              print('Topics: $topics');
              print('Link to Research Paper: $link');

              // Clear text fields after submission
              _titleController.clear();
              _abstractController.clear();
              _topicsController.clear();
              _linkController.clear();

              // Show a success message or navigate to another screen
            },
            child: Text('Submit Paper'),
          ),
        ],
      ),
    );
  }
}
