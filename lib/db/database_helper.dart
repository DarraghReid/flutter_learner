import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/topic.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'topics.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

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

  Future<int> insertTopic(Topic topic) async {
    final db = await database;
    return await db.insert('topics', topic.toMap());
  }

  Future<List<Topic>> getAllTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('topics');

    return List.generate(maps.length, (i) => Topic.fromMap(maps[i]));
  }

  Future<int> updateTopic(Topic topic) async {
    final db = await database;
    return await db.update(
      'topics',
      topic.toMap(),
      where: 'id = ?',
      whereArgs: [topic.id],
    );
  }

  Future<int> deleteTopic(int id) async {
    final db = await database;
    return await db.delete(
      'topics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
