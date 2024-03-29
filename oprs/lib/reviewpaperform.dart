import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
    int relevanceS = int.parse(relevanceScore.text);
    int ethicalityS = int.parse(ethicalityScore.text);
    int understandabilityS = int.parse(understandabilityScore.text);
    int acknowledgementS = int.parse(acknowledgementScore.text);
    int citationsS = int.parse(citationsScore.text);
    if ((noveltyS > 10 ||
            accuracyS > 10 ||
            relevanceS > 10 ||
            ethicalityS > 10 ||
            understandabilityS > 10 ||
            acknowledgementS > 10 ||
            citationsS > 10) ||
        (noveltyS < 0 ||
            accuracyS < 0 ||
            relevanceS < 0 ||
            ethicalityS < 0 ||
            understandabilityS < 0 ||
            acknowledgementS < 0 ||
            citationsS < 0)) {
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
              acknowledgementS +
              citationsS) / 7;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'reviews') // Replace 'your_collection' with the name of your collection in Firestore
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
      body: Row(
        children: [
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Novelty Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: noveltyScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Accuracy Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: accuracyScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Relevance Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: relevanceScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Ethicality Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: ethicalityScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Understandability Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: understandabilityScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Acknowledgement Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: acknowledgementScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text("Citations Score:  ", textScaler:TextScaler.linear(1.2))
                  ),
                  SizedBox(
                    width: 75,
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: citationsScore,
                      decoration: const InputDecoration(
                        border:OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _reviewPaper(context),
                child: const Text('Submit Review'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
