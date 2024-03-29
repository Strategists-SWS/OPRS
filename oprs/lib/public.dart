import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oprs/submitpaperform.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmitPage extends StatelessWidget {
  final String userId;

  SubmitPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Papers'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('papers')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No papers submitted yet.'),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                DateTime submissionDate = (document['submissionDate'] as Timestamp).toDate();
                Duration timeDifference = DateTime.now().difference(submissionDate);
                String timeSinceSubmission = '${timeDifference.inDays} days ago';

                return ListTile(
                  title: Text(document['title']),
                  subtitle: Text(timeSinceSubmission),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the upload page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPaperPage()),
            );  
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
