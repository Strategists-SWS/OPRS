import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/sign_in.dart';
import 'package:oprs/reviewpaperform.dart';

class Abc extends StatelessWidget {
  const Abc({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any loading indicator
        }

        if (snapshot.hasData) {
          String userId = snapshot.data!.uid;
          return AssignedPapersPage(userId: userId);
        } else {
          return const MyLoginPage(); // Navigate to your sign in screen if the user is not logged in
        }
      },
    );
  }
}

class AssignedPapersPage extends StatelessWidget {
  final String userId;

  const AssignedPapersPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Papers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('papers')
            .where("assignedTo", arrayContains: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No papers assigned yet.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              DateTime assignmentDate =
                  (document['submissionDate'] as Timestamp).toDate();
              Duration timeDifference =
                  DateTime.now().difference(assignmentDate);
              String timeSinceAssignment = '${timeDifference.inDays} days ago';
              bool canGrade = timeDifference.inDays < 14;

              return ListTile(
                title: Text(document['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timeSinceAssignment),
                    if (canGrade) const Text('You can grade this paper.'),
                  ],
                ),
                onTap: canGrade
                    ? () async {
                        String pdfUrl = document['url'];
                        if (document['isReviewed'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'This paper has already been reviewed.'),
                          ));
                          return;
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewForm(url: pdfUrl),
                            ),
                          );
                        }
                        if (await canLaunchUrl(Uri.parse(pdfUrl))) {
                          await launchUrl(Uri.parse(pdfUrl));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Could not open PDF.'),
                          ));
                        }
                      }
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
