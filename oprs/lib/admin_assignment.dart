import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResearchPaperList extends StatelessWidget {
  const ResearchPaperList({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('papers').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator while data is being fetched
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No research papers available.');
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> paperData = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(paperData['title']),
              subtitle: Text('Related Topics: ${paperData['relatedTopics']}'),
              onTap: () {
                // Navigate to UserListPage passing paperData
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserListPage(paperData: paperData)),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class UserListPage extends StatelessWidget {
  final Map<String, dynamic> paperData;

  const UserListPage({super.key, required this.paperData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users with Similar Topics'),
      ),
      body: SimilarUsersList(
        paperData: paperData,
        currentUserUid: paperData['userId'],
      ),
    );
  }
}

class SimilarUsersList extends StatelessWidget {
  final Map<String, dynamic> paperData;
  final String
      currentUserUid; // Add this variable to hold the UID of the user who posted the paper

  const SimilarUsersList(
      {Key? key, required this.paperData, required this.currentUserUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('topics', arrayContainsAny: paperData['relatedTopics'])
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator while data is being fetched
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No users with similar topics found.');
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
            // Check if the user's UID is not the same as the currentUserUid
            if (userData['userId'] != currentUserUid) {
              return ListTile(
                title: Text(userData['name']),
                onTap: () {
                  // Navigate to AssignPaperPage passing userData and paperData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignPaperPage(
                            userData: userData, paperData: paperData)),
                  );
                },
              );
            } else {
              // Return an empty Container for the user who posted the paper
              return Container();
            }
          }).toList(),
        );
      },
    );
  }
}

class AssignPaperPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> paperData;

  const AssignPaperPage(
      {super.key, required this.userData, required this.paperData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Paper'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Perform assignment logic here
            // For example, update the Firestore document for the paper with assigned user details
            // Then navigate back to the previous screen
            // Get the reference to the Firestore document for the paper
            QuerySnapshot paperRef = await FirebaseFirestore.instance
                .collection('papers')
                .where('paperId', isEqualTo: paperData['paperId'])
                .get();

            QuerySnapshot reviewRef = await FirebaseFirestore.instance
                .collection('reviews')
                .where('paperId', isEqualTo: paperData['paperId'])
                .get();

            if (reviewRef.docs.isEmpty) {
              // If the document doesn't exist, create a new one
              await FirebaseFirestore.instance.collection('reviews').add({
                'paperId': paperData['paperId'],
                'grade': {userData['userId']: null},
              });
            } else {
              // If the document exists, update it to append the userId to the grade array
              for (QueryDocumentSnapshot documentSnapshot in reviewRef.docs) {
                await documentSnapshot.reference.update({
                  'grade.${userData['userId']}': null,
                });
              }
            }
            for (QueryDocumentSnapshot documentSnapshot in paperRef.docs) {
              await documentSnapshot.reference.update({
                'assignedTo': FieldValue.arrayUnion([userData['userId']]),
              });
            }

            //create a document in the reviews collection with fields isReviewed = false, grade = null, paperId = paperData['paperId']

            // Navigate back to the previous screen
            Navigator.pop(context);
          },
          child: Text('Assign to ${userData['name']}'),
        ),
      ),
    );
  }
}
