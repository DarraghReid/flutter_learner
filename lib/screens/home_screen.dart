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
        title: Row(
            children: [
                Image.asset('assets/flutter_logo.png', height: 32),
                const SizedBox(width: 10),
                const Text('Flutter Learner'),
            ],
        ),
      ),
      body: topicProvider.topics.isEmpty
        ? const Center(child: Text('No topics yet. Add one!'))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Progress indicator
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                'Progress: ${topicProvider.topics.where((t) => t.isDone).length} of ${topicProvider.topics.length} topics completed',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
            ),

            // Expanded list view of sorted topics
            Expanded(
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.builder(
                    itemCount: topicProvider.topics.length,
                    itemBuilder: (context, index) {
                    // Sort topics: incomplete first
                    final sortedTopics = [...topicProvider.topics]
                        ..sort((a, b) => (a.isDone ? 1 : 0) - (b.isDone ? 1 : 0));

                    final topic = sortedTopics[index];

                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                            title: Text(
                            topic.title,
                            style: TextStyle(
                                decoration: topic.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                            ),
                            ),
                            subtitle: Text(topic.description),
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
                                onPressed: () {
                                    topicProvider.deleteTopic(topic.id!);
                                },
                                ),
                            ],
                            ),
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => TopicDetailScreen(topic: topic),
                                ),
                            );
                            },
                        ),
                        ),
                    );
                    },
                ),
                ),
            ),
            ],
        ),

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
