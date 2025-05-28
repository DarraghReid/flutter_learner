import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/topic.dart';

/// Helper class for managing the SQLite database and CRUD operations for topics.
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor returns the singleton instance
  factory DatabaseHelper() => _instance;

  // Private internal constructor
  DatabaseHelper._internal();

  // Database instance
  static Database? _database;

  /// Getter for the database. Initializes the database if it's not already created.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and creates the topics table if it doesn't exist.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath(); // Get the default database path
    final path = join(dbPath, 'topics.db');  // Set the database file name

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // Callback to create tables
    );
  }

  /// Callback to create the topics table when the database is first created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE topics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isDone INTEGER NOT NULL,
        notes TEXT
      )
    ''');
  }

  /// Inserts a new topic into the database.
  Future<int> insertTopic(Topic topic) async {
    final db = await database;
    return await db.insert('topics', topic.toMap());
  }

  /// Retrieves all topics from the database.
  Future<List<Topic>> getAllTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('topics');

    return List.generate(maps.length, (i) => Topic.fromMap(maps[i]));
  }

  /// Updates an existing topic in the database.
  Future<int> updateTopic(Topic topic) async {
    final db = await database;
    return await db.update(
      'topics',
      topic.toMap(),
      where: 'id = ?',
      whereArgs: [topic.id],
    );
  }

  /// Deletes a topic from the database by its [id].
  Future<int> deleteTopic(int id) async {
    final db = await database;
    return await db.delete(
      'topics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}