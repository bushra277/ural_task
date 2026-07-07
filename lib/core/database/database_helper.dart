import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    try {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;

      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = p.join(documentsDirectory.path, 'tasks.db');

      _database = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createTable,
        ),
      );
      return _database!;
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  static Future<void> _createTable(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        due_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
        ) 
      ''');
    } catch (e) {
      throw Exception('Failed to create tasks table: $e');
    }
  }
}