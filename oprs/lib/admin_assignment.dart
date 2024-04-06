import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResearchPaperList extends StatelessWidget {
  const ResearchPaperList({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('papers').snapshots(),
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

  UserListPage({required this.paperData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users with Similar Topics'),
      ),
      body: SimilarUsersList(paperData: paperData),
    );
  }
}

class SimilarUsersList extends StatelessWidget {
  final Map<String, dynamic> paperData;

  SimilarUsersList({required this.paperData});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('topics', arrayContainsAny: paperData['relatedTopics'])
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while data is being fetched
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No users with similar topics found.');
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
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
          }).toList(),
        );
      },
    );
  }
}

class AssignPaperPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> paperData;

  AssignPaperPage({required this.userData, required this.paperData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Paper'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform assignment logic here
            // For example, update the Firestore document for the paper with assigned user details
            // Then navigate back to the previous screen
          },
          child: Text('Assign to ${userData['name']}'),
        ),
      ),
    );
  }
}
