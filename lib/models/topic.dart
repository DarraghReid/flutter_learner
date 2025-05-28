/// Model class representing a Topic item.
class Topic {
  /// Unique identifier for the topic (nullable for new topics).
  final int? id;

  /// Title of the topic.
  final String title;

  /// Description of the topic.
  final String description;

  /// Whether the topic is marked as done.
  final bool isDone;

  /// Optional notes for the topic.
  final String? notes;

  /// Constructs a [Topic] instance.
  Topic({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.notes,
  });

  /// Converts the [Topic] instance to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0, // Store bool as int in database
      'notes': notes,
    };
  }

  /// Creates a [Topic] instance from a map (e.g., from the database).
  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1, // Convert int back to bool
      notes: map['notes'],
    );
  }
}