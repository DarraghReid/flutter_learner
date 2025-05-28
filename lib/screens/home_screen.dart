import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/topic_provider.dart';
import '../models/topic.dart';
import 'add_topic_screen.dart';
import 'topic_detail_screen.dart';

/// The main screen that displays the list of Flutter topics
/// and allows users to add, edit, or delete topics.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  /// Load topics from the database the first time this screen is shown.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<TopicProvider>(context, listen: false).loadTopics();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the current state of topics using Provider
    final topicProvider = Provider.of<TopicProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Learner'),
      ),
      body: topicProvider.topics.isEmpty
          ? const Center(
              child: Text('No topics yet. Add one!'),
            )
          : ListView.builder(
              itemCount: topicProvider.topics.length,
              itemBuilder: (context, index) {
                final topic = topicProvider.topics[index];

                return ListTile(
                  // Topic title with optional strikethrough if marked as done
                  title: Text(
                    topic.title,
                    style: TextStyle(
                      decoration: topic.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  // Short description shown as subtitle
                  subtitle: Text(topic.description),

                  // Checkbox to mark topic as done or not
                  leading: Checkbox(
                    value: topic.isDone,
                    onChanged: (val) {
                      // Update the topic with the new isDone status
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

                  // Row of edit/delete icons
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the AddTopic screen with the topic to edit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddTopicScreen(topicToEdit: topic), 
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                            final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                title: const Text('Delete Topic'),
                                content: const Text('Are you sure you want to delete this topic?'),
                                actions: [
                                    TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                ],
                                ),
                            );

                            if (confirm == true) {
                                topicProvider.deleteTopic(topic.id!);
                            }
                        },
                      ),
                    ],
                  ),

                  // Navigate to topic detail screen on tap
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => TopicDetailScreen(topic: topic),
                        ),
                    );
                  },
                );
              },
            ),

      // Floating action button to add a new topic
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTopic screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTopicScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
