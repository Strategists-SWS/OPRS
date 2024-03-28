import 'package:flutter/material.dart';
import 'package:oprs/submitpaperform.dart'; 

// Define a class for research papers
class ResearchPaper {
  final String title;
  final DateTime submissionTime;

  ResearchPaper({required this.title, required this.submissionTime});
}

// Sample data for research papers
List<ResearchPaper> reviewPapers = [
  ResearchPaper(title: "Paper 1", submissionTime: DateTime.now()),
  ResearchPaper(title: "Paper 2", submissionTime: DateTime.now()),
  ResearchPaper(title: "Paper 3", submissionTime: DateTime.now()),
  // Add more sample data as needed
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
                // Calculate time left
                Duration difference = DateTime.now().difference(reviewPapers[index].submissionTime);

                // Format time left
                String timeLeft = "${difference.inHours}h ${difference.inMinutes.remainder(60)}m";

                return InkWell(
                  onTap: () {
                    // Handle paper title tap
                    print('Paper title tapped: ${reviewPapers[index].title}');
                  },
                  child: ListTile(
                    title: Text(reviewPapers[index].title),
                    trailing: Text(
                      'Time Left: $timeLeft',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new paper action
           Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPaperPage()), // Navigate to the Submit Paper page
    );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

