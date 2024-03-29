import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewForm extends StatelessWidget {
  const ReviewForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Paper'),
      ),
      body: const ReviewPage(),
    );
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});
  @override
  ReviewFormPage createState() => ReviewFormPage();
}

class ReviewFormPage extends State<ReviewPage> {
  TextEditingController noveltyScore=TextEditingController();
  TextEditingController accuracyScore=TextEditingController();
  TextEditingController relevanceScore=TextEditingController();
  TextEditingController ethicalityScore=TextEditingController();
  TextEditingController understandabilityScore=TextEditingController();
  TextEditingController acknowledgementScore=TextEditingController();
  TextEditingController citationsScore=TextEditingController();

  void _reviewPaper(BuildContext pcontext) async {
    if (noveltyScore.text.isEmpty || accuracyScore.text.isEmpty || relevanceScore.text.isEmpty || ethicalityScore.text.isEmpty || understandabilityScore.text.isEmpty || acknowledgementScore.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Fields can't be empty"),
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
    int noveltyS = int.parse(noveltyScore.text);
    int accuracyS = int.parse(accuracyScore.text);
    int relevanceS = int.parse(noveltyScore.text);
    int ethicalityS = int.parse(accuracyScore.text);
    int understandabilityS = int.parse(noveltyScore.text);
    int acknowledgementS = int.parse(accuracyScore.text);
    if((noveltyS>5||accuracyS>5||relevanceS>5||ethicalityS>5||understandabilityS>5||acknowledgementS>5)||(noveltyS<0||accuracyS<0||relevanceS<0||ethicalityS<0||understandabilityS<0||acknowledgementS<0))
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Scores Should be in range 0-5"),
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
    else {
      DateTime submissionDate = DateTime.now();
     
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('pdfs/${submissionDate.millisecondsSinceEpoch}.pdf');
      double netS=(noveltyS+accuracyS+relevanceS+ethicalityS+understandabilityS+acknowledgementS)/6;

      // Store paper details in Firestore
      await FirebaseFirestore.instance.collection('papers').add({
        'userId': user.uid,
        'score': netS,
        'submissionDate': submissionDate,
      });
      // Show success message and return to the Review widget
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("The paper has been reviewed successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(pcontext);
                },
                child: const Text("Close"),
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
        title: const Text('Review Papers'),
      ),
      body: Column(
          children: [
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: noveltyScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Novelty'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: accuracyScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Accuracy'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: relevanceScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Relevance'),
              ),
            ),

            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: ethicalityScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Ethicality'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: understandabilityScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Understandability'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: acknowledgementScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Acknowledgement of Limitations'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: citationsScore,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Appropriate Citations'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _reviewPaper(context),
              child: const Text('Submit Paper'),
          ),
          ],
      )
    );
  }
}