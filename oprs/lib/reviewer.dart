import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oprs/score.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers submitted on the platform'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No papers reviewed yet.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              Future<Map<String, dynamic>> paperFuture = FirebaseFirestore
                  .instance
                  .collection('papers')
                  .where('paperId', isEqualTo: document['paperId'])
                  .get()
                  .then((value) => value.docs.first.data());

              return FutureBuilder<Map<String, dynamic>>(
                future: paperFuture,
                builder: (context, paperSnapshot) {
                  if (paperSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final paperData = paperSnapshot.data ?? {};

                  final title = paperData['title'] ?? 'Title not found';
                  final pdfUrl = paperData['url'] ?? '';

                  return ListTile(
                    title: Text(title),
                    onTap: () async {
                      if (pdfUrl.isNotEmpty) {
                        String documentTitle = title;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Document: $documentTitle"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Title: $title'),
                                const SizedBox(height: 10),
                                PaperScoreWidget(paperId: document['paperId']),
                                const SizedBox(height: 10),
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
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('PDF URL not found.'),
                        ));
                      }
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
