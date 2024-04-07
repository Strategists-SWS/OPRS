import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oprs/sign_in.dart';
import 'package:oprs/reviewpaperform.dart';
import 'dart:async';

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

class AssignedPapersPage extends StatefulWidget {
  final String userId;

  const AssignedPapersPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AssignedPapersPageState createState() => _AssignedPapersPageState();
}

class _AssignedPapersPageState extends State<AssignedPapersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Papers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('papers')
            .where("assignedTo", arrayContains: widget.userId)
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              return PaperListItem(
                document: document,
                userId: widget.userId,
              );
            },
          );
        },
      ),
    );
  }
}

class PaperListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> document;
  final String userId;

  const PaperListItem({
    Key? key,
    required this.document,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime assignmentDate =
        (document['submissionDate'] as Timestamp).toDate();
    DateTime currentTime = DateTime.now();
    Duration elapsedTime = currentTime.difference(assignmentDate);
    bool canGrade = elapsedTime.inDays < 14;

    return ListTile(
      title: Text(document['title']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimeLeftWidget(
              elapsedTime: elapsedTime), // Use separate widget for time left
          if (canGrade) const Text('You can grade this paper.'),
        ],
      ),
      onTap: canGrade
          ? () async {
              // your onTap logic
            }
          : null,
    );
  }
}

class TimeLeftWidget extends StatefulWidget {
  final Duration elapsedTime;

  const TimeLeftWidget({Key? key, required this.elapsedTime}) : super(key: key);

  @override
  _TimeLeftWidgetState createState() => _TimeLeftWidgetState();
}

class _TimeLeftWidgetState extends State<TimeLeftWidget> {
  late Timer _timer;
  late String _timeLeftString;

  @override
  void initState() {
    super.initState();
    _timeLeftString = _getTimeLeft(widget.elapsedTime);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeftString =
            _getTimeLeft(widget.elapsedTime + Duration(seconds: timer.tick));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeLeftString,
      style: TextStyle(fontSize: 16), // Customize style as needed
    );
  }

  String _getTimeLeft(Duration difference) {
    // Calculate total time left in seconds
    int totalTimeLeftInSeconds = 14 * 24 * 60 * 60;

    // Calculate elapsed time in seconds
    int elapsedTimeInSeconds = difference.inSeconds;

    // Calculate remaining time
    int remainingTimeInSeconds = totalTimeLeftInSeconds - elapsedTimeInSeconds;

    // Ensure remaining time is not negative
    if (remainingTimeInSeconds <= 0) {
      return 'Time Left: 0 days 0 hours 0 minutes 0 seconds';
    }

    // Convert remaining time to days, hours, minutes, and seconds
    int daysLeft = remainingTimeInSeconds ~/ (24 * 60 * 60);
    remainingTimeInSeconds %= (24 * 60 * 60);
    int hoursLeft = remainingTimeInSeconds ~/ (60 * 60);
    remainingTimeInSeconds %= (60 * 60);
    int minutesLeft = remainingTimeInSeconds ~/ 60;
    remainingTimeInSeconds %= 60;

    // Return formatted time left string
    return 'Time Left: $daysLeft days $hoursLeft hours $minutesLeft minutes $remainingTimeInSeconds seconds';
  }
}
