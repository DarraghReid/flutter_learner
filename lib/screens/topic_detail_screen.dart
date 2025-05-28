import 'package:flutter/material.dart';
import '../models/topic.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({Key? key, required this.topic}) : super(key: key);

  @override
  // Build the UI for the topic detail screen
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              topic.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              topic.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Completion status
            Row(
              children: [
                const Text('Completed: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(
                  topic.isDone ? Icons.check_circle : Icons.cancel,
                  color: topic.isDone ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Notes
            if (topic.notes != null && topic.notes!.isNotEmpty) ...[
              const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(topic.notes!),
            ] else
              const Text('No notes yet.', style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
