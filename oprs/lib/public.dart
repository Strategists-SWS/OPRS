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
List<ResearchPaper> reviewPapers = [
  ResearchPaper(title: "Paper 1", author: "Author 1", score: 4.5),
  ResearchPaper(title: "Paper 2", author: "Author 2", score: 3.8),
  ResearchPaper(title: "Paper 3", author: "Author 3", score: 4.2),
  // Add more sample data as needed
];

List<ResearchPaper> submittedPapers = [
  ResearchPaper(title: "Submitted Paper 1", author: "", score: 0),
  ResearchPaper(title: "Submitted Paper 2", author: "", score: 0),
  ResearchPaper(title: "Submitted Paper 3", author: "", score: 0),
  // Add more dummy data as needed
];

class Review extends StatelessWidget {
  const Review({Key? key});

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
  const ResearchPaperPage({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Papers'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reviewPapers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reviewPapers[index].title),
                  subtitle: Text(reviewPapers[index].author),
                  trailing: Text(
                    'Score: ${reviewPapers[index].score.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: submittedPapers.length,
              itemBuilder: (context, index) {
                // Calculate time left
                DateTime now = DateTime.now();
                DateTime paperSubmittedTime = DateTime.now().subtract(Duration(hours: 1)); // Dummy value for submitted time
                Duration difference = paperSubmittedTime.difference(now);

                // Format time left
                String timeLeft = "${difference.inHours}h ${difference.inMinutes.remainder(60)}m";

                return ListTile(
                  title: Text(submittedPapers[index].title),
                  trailing: Text(
                    'Time Left: $timeLeft',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

