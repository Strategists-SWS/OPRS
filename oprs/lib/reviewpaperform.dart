import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewForm extends StatelessWidget {
  final String url;
  ReviewForm({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Paper'),
      ),
      body: ReviewPage(url: url),
    );
  }
}

class ReviewPage extends StatefulWidget {
  final String url;
  const ReviewPage({required this.url});
  @override
  _ReviewFormPageState createState() => _ReviewFormPageState(url);
}

class _ReviewFormPageState extends State<ReviewPage> {
  final String url;
  _ReviewFormPageState(this.url);

  TextEditingController noveltyScore = TextEditingController();
  TextEditingController accuracyScore = TextEditingController();
  TextEditingController relevanceScore = TextEditingController();
  TextEditingController ethicalityScore = TextEditingController();
  TextEditingController understandabilityScore = TextEditingController();
  TextEditingController acknowledgementScore = TextEditingController();
  TextEditingController citationsScore = TextEditingController();

  void _reviewPaper(BuildContext pcontext) async {
    // Validation and score parsing logic
    if (noveltyScore.text.isEmpty ||
        accuracyScore.text.isEmpty ||
        relevanceScore.text.isEmpty ||
        ethicalityScore.text.isEmpty ||
        understandabilityScore.text.isEmpty ||
        acknowledgementScore.text.isEmpty) {
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
    if ((noveltyS > 10 ||
            accuracyS > 10 ||
            relevanceS > 10 ||
            ethicalityS > 10 ||
            understandabilityS > 10 ||
            acknowledgementS > 10) ||
        (noveltyS < 0 ||
            accuracyS < 0 ||
            relevanceS < 0 ||
            ethicalityS < 0 ||
            understandabilityS < 0 ||
            acknowledgementS < 0)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Scores Should be in range 0-10"),
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
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      double netS = (noveltyS +
              accuracyS +
              relevanceS +
              ethicalityS +
              understandabilityS +
              acknowledgementS) /
          6;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'your_collection') // Replace 'your_collection' with the name of your collection in Firestore
          .where('url', isEqualTo: url)
          .get();

      Map<String, dynamic> newData = {
        'isReviewed': true,
        'userId': user.uid,
        'grade': netS,
      };
      // Loop through each document with matching URL and update the data
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.update(newData);
      }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            controller: noveltyScore,
            decoration: const InputDecoration(
              labelText: 'Novelty',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: accuracyScore,
            decoration: const InputDecoration(
              labelText: 'Accuracy',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: relevanceScore,
            decoration: const InputDecoration(
              labelText: 'Relevance',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: ethicalityScore,
            decoration: const InputDecoration(
              labelText: 'Ethicality',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: understandabilityScore,
            decoration: const InputDecoration(
              labelText: 'Understandability',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: acknowledgementScore,
            decoration: const InputDecoration(
              labelText: 'Acknowledgement of Limitations',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: citationsScore,
            decoration: const InputDecoration(
              labelText: 'Appropriate Citations',
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _reviewPaper(context),
            child: const Text('Submit Paper'),
          ),
        ],
      ),
    );
  }
}
