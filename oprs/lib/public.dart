import 'package:flutter/material.dart';

// Define a class for research papers
class ResearchPaper {
  final String title;
  final String author;
  final double score;

  ResearchPaper(
      {required this.title, required this.author, required this.score});
}

// Sample data for research papers
List<ResearchPaper> researchPapers = [
  ResearchPaper(title: "Paper 1", author: "Author 1", score: 4.5),
  ResearchPaper(title: "Paper 2", author: "Author 2", score: 3.8),
  ResearchPaper(title: "Paper 3", author: "Author 3", score: 4.2),
  // Add more sample data as needed
];

class Review extends StatelessWidget {
  const Review({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research Papers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ResearchPaperPage(),
    );
  }
}

class ResearchPaperPage extends StatelessWidget {
  const ResearchPaperPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Papers'),
      ),
      body: ListView.builder(
        itemCount: researchPapers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(researchPapers[index].title),
            subtitle: Text(researchPapers[index].author),
            trailing: Text(
              'Score: ${researchPapers[index].score.toString()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
