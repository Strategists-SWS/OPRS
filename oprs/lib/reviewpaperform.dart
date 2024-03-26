import 'package:flutter/material.dart';

// Define a class for research papers
class ReviewPaper {
  final String title;
  final String author;
  final double score;
  final bool reviewed;

  ReviewPaper(
      {required this.title, required this.author, required this.score, required this.reviewed});
}

// Sample data for research papers
List<ReviewPaper> researchPapers = [
  ReviewPaper(title: "Paper 1", author: "Author 1", score: 0, reviewed: false),
  ReviewPaper(title: "Paper 2", author: "Author 2", score: 4, reviewed: true),
  ReviewPaper(title: "Paper 3", author: "Author 3", score: 0, reviewed: false),
  // Add more sample data as needed
];

class ReviewForm extends StatelessWidget {
  const ReviewForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research Papers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReviewFormPage(),
    );
  }
}

class ReviewFormPage extends StatelessWidget {
  const ReviewFormPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Papers'),
      ),
      body: Column(
          children: [
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Novelty'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Correctness'),
              ),
            ),
          ],
      )
    );
  }
}