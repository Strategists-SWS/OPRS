import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers reviewed on the platform'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No papers reviewed yet.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              DateTime submissionDate =
                  (document['submissionDate'] as Timestamp).toDate();
              Duration timeDifference =
                  DateTime.now().difference(submissionDate);
              String timeSinceSubmission = '${timeDifference.inDays} days ago';

              // Retrieving grade from Firestore document
              double grade = document['grade'] ??
                  0; // Assuming grade is stored as a double in Firestore

              return ListTile(
                title: Text(document['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Grade: $grade/10'), // Displaying grade on a scale of 10
                    Text(timeSinceSubmission),
                  ],
                ),
                onTap: () async {
                  String pdfUrl = document['url'];
                  if (await canLaunchUrl(Uri.parse(pdfUrl))) {
                    await launchUrl(Uri.parse(pdfUrl));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Could not open PDF.'),
                    ));
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
