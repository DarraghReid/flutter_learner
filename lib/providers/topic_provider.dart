import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/topic.dart';

/// Provider class for managing the list of topics and notifying listeners on changes.
class TopicProvider with ChangeNotifier {
  // Internal list of topics.
  List<Topic> _topics = [];

  // Public getter for the list of topics.
  List<Topic> get topics => _topics;

  // Instance of the database helper for CRUD operations.
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Loads all topics from the database and notifies listeners.
  Future<void> loadTopics() async {
    _topics = await _dbHelper.getAllTopics();
    notifyListeners();
  }

  /// Adds a new topic to the database and reloads the topic list.
  Future<void> addTopic(Topic topic) async {
    await _dbHelper.insertTopic(topic);
    await loadTopics();
  }

  /// Updates an existing topic in the database and reloads the topic list.
  Future<void> updateTopic(Topic topic) async {
    await _dbHelper.updateTopic(topic);
    await loadTopics();
  }

  /// Deletes a topic by its [id] from the database and reloads the topic list.
  Future<void> deleteTopic(int id) async {
    await _dbHelper.deleteTopic(id);
    await loadTopics();
  }

  /// Preloads sample topics into the database if the list is empty.
  Future<void> preloadTopicsIfNeeded() async {
    if (_topics.isEmpty) {
        final sampleTopics = [
        Topic(title: 'Widgets', description: 'Building blocks of Flutter UI'),
        Topic(title: 'State Management', description: 'Manage app state effectively'),
        Topic(title: 'Navigation', description: 'Navigate between screens'),
        Topic(title: 'SQLite', description: 'Store data locally using sqflite'),
        Topic(title: 'Provider', description: 'Recommended state management tool'),
        ];

        for (final topic in sampleTopics) {
        await DatabaseHelper().insertTopic(topic);
        }

        await loadTopics(); // Reload after inserting
    }
  }
}