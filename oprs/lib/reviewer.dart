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

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research Papers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReviewPaperPage(),
    );
  }
}

class ReviewPaperPage extends StatelessWidget {
  const ReviewPaperPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Papers'),
      ),
      body: ListView.builder(
        itemCount: researchPapers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(researchPapers[index].title),
            subtitle: Text(researchPapers[index].author),
            trailing: TextButton(
              child: Text('Score: ${researchPapers[index].score.toString()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {}
            ),
          );
        },
      ),
    );
  }
}
