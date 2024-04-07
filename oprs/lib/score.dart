import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaperScoreWidget extends StatelessWidget {
  final String paperId;

  const PaperScoreWidget({super.key, required this.paperId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('reviews')
          .where('paperId', isEqualTo: paperId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Not graded yet');
        }

        var totalScore = 0.0;
        var count = 0;

        snapshot.data!.docs.forEach((doc) {
          var grades = doc['grade'];
          if (grades != null && grades.isNotEmpty) {
            grades.forEach((userId, score) {
              if (score != null) {
                totalScore += score;
                count++;
              }
            });
          }
        });

        if (count == 0) {
          return Text('Not graded yet');
        }

        var averageScore = totalScore / count;
        return Text('Average score: $averageScore');
      },
    );
  }
}
