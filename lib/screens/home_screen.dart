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
                // Display a message when there are no topics
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                    Icon(Icons.lightbulb_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                    'No topics yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Tap the + button to add your first topic.'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: topicProvider.topics.length,
              itemBuilder: (context, index) {
                final topic = topicProvider.topics[index];

                return Card(
                    // Add some padding around each topic card
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Topic deleted')),
                                );
                                }
                            },
                            ),
                        ],
                        ),
                        leading: Checkbox(
                        value: topic.isDone,
                        onChanged: (val) {
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => TopicDetailScreen(topic: topic),
                            ),
                        );
                      },
                    ),
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
