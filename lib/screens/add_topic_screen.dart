import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../providers/topic_provider.dart';

/// Screen for adding a new topic or editing an existing one.
class AddTopicScreen extends StatefulWidget {
  final Topic? topicToEdit;

  const AddTopicScreen({Key? key, this.topicToEdit}) : super(key: key);

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

  // Initialize the state, pre-filling the form if editing an existing topic.
  @override
  void initState() {
    super.initState();
    if (widget.topicToEdit != null) {
        _titleController.text = widget.topicToEdit!.title;
        _descriptionController.text = widget.topicToEdit!.description;
        _notesController.text = widget.topicToEdit!.notes ?? '';
    }
  }

  // Method to save the topic, either adding a new one or updating an existing one.
  void _saveTopic() {
  if (_formKey.currentState!.validate()) {
    final topic = Topic(
      id: widget.topicToEdit?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isDone: widget.topicToEdit?.isDone ?? false,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    final provider = Provider.of<TopicProvider>(context, listen: false);

    if (widget.topicToEdit == null) {
        // If no topic is being edited, add a new topic
        provider.addTopic(topic);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Topic added successfully!')),
        );
    } else {
        // If editing an existing topic, update it
        provider.updateTopic(topic);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Topic updated successfully!')),
        );
    }

    Navigator.pop(context);
  }
}


  @override
  // Build the UI for adding a new topic
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicToEdit != null ? 'Edit Topic' : 'Add New Topic'),
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
                child: Text(widget.topicToEdit == null ? 'Add Topic' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}