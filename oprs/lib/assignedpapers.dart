import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/sign_in.dart';

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

  AssignedPapersPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Papers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('assignedTo', isEqualTo: userId)
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
                  (document['assignmentDate'] as Timestamp).toDate();
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
                    if (canGrade) Text('You can grade this paper.'),
                  ],
                ),
                onTap: canGrade
                    ? () async {
                        String pdfUrl = document['url'];
                        if (await canLaunch(pdfUrl)) {
                          await launch(pdfUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Could not open PDF.'),
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
