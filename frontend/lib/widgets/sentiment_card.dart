
import 'package:flutter/material.dart';
import '../models/sentiment.dart';

class SentimentCard extends StatelessWidget {
  final Sentiment sentiment;

  const SentimentCard({super.key, required this.sentiment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Sentiment: \${sentiment.sentiment}'),
            Text('Confidence: \${(sentiment.confidence * 100).toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }
}
