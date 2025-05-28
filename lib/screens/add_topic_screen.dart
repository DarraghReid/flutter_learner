import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../providers/topic_provider.dart';

/// Screen for adding a new topic.
class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({super.key});

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  // Key to identify the form and validate input.
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  /// Handles saving the topic when the form is valid.
  void _saveTopic() {
    if (_formKey.currentState!.validate()) {
      final newTopic = Topic(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isDone: false,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // Add the new topic using the provider.
      Provider.of<TopicProvider>(context, listen: false).addTopic(newTopic);
      Navigator.pop(context); // Go back to the home screen
    }
  }

  @override
  // Build the UI for adding a new topic
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Validates inputs
          child: Column(
            children: [
              // Title input field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 10),
              // Description input field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 10),
              // Notes input field (optional)
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Button to submit the form and add the topic
              ElevatedButton(
                onPressed: _saveTopic,
                child: const Text('Add Topic'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}