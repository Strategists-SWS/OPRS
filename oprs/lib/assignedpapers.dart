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
          return const AssignedPapersPage();
        } else {
          return const MyLoginPage(); // Navigate to your sign in screen if the user is not logged in
        }
      },
    );
  }
}

class AssignedPapersPage extends StatefulWidget {
  const AssignedPapersPage({super.key});

  @override
  _AssignedPapersPageState createState() => _AssignedPapersPageState();
}

class _AssignedPapersPageState extends State<AssignedPapersPage> {
  String userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Papers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('papers')
            .where("assignedTo", arrayContains: userid)
            .snapshots(),
        builder: (context, snapshot) {
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
                userId: userid,
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

  const PaperListItem({super.key,required this.document, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('reviews')
          .where('paperId', isEqualTo: document['paperId'])
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first;
        } else {
          throw Exception('Assignment not found');
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Assignment not found');
        }

        DateTime assignmentDate =
            (snapshot.data!['time'][userId] as Timestamp).toDate();
        DateTime currentTime = DateTime.now();
        Duration elapsedTime = currentTime.difference(assignmentDate);
        bool canGrade = elapsedTime.inDays < 14;

        return ListTile(
          title: Text(document['title']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimeLeftWidget(
                  elapsedTime:
                      elapsedTime), // Use separate widget for time left
              if (canGrade) const Text('You can grade this paper.'),
            ],
          ),
          onTap: () async {
            String pdfUrl = document['url'];

            // Close current SnackBar if open
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: ${document['title']}"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await canLaunch(pdfUrl)) {
                            await launch(pdfUrl);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Could not open PDF.'),
                            ));
                          }
                        },
                        child: const Text('Download Paper'),
                      ),
                      if (canGrade)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReviewForm(
                                paperId: document['paperId'],
                              ),
                            ));
                          },
                          child: const Text('Grade Paper'),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ));
          },
        );
      },
    );
  }
}

class TimeLeftWidget extends StatefulWidget {
  final Duration elapsedTime;

  const TimeLeftWidget({super.key, required this.elapsedTime});

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
