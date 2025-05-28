import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/topic_provider.dart';
import '../models/topic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access TopicProvider (state) using Provider
    final topicProvider = Provider.of<TopicProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Learner'),
      ),
      body: topicProvider.topics.isEmpty
          ? const Center(child: Text('No topics yet. Add one!'))
          : ListView.builder(
              itemCount: topicProvider.topics.length,
              itemBuilder: (context, index) {
                final topic = topicProvider.topics[index];

                return ListTile(
                  title: Text(
                    topic.title,
                    style: TextStyle(
                      decoration: topic.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(topic.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Navigate to edit screen
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          topicProvider.deleteTopic(topic.id!);
                        },
                      ),
                    ],
                  ),
                  leading: Checkbox(
                    value: topic.isDone,
                    onChanged: (val) {
                      // Update topic with new isDone value
                      topicProvider.updateTopic(
                        Topic(
                          id: topic.id,
                          title: topic.title,
                          description: topic.description,
                          isDone: val ?? false,
                          notes: topic.notes,
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    // TODO: View or edit topic details
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
