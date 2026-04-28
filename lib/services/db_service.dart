import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class DBService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      'reports.db',
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT,
            title TEXT,
            type TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        try {
          await db.execute('ALTER TABLE reports ADD COLUMN title TEXT');
        } catch (e) {}

        try {
          await db.execute('ALTER TABLE reports ADD COLUMN type TEXT');
        } catch (e) {}
      },
    );

    return _database!;
  }

  static Future<void> saveReport({
    required List<Map<String, dynamic>> items,
    required String title,
    required String type,
  }) async {
    final db = await database;

    String data = jsonEncode(items);

    await db.insert('reports', {'data': data, 'title': title, 'type': type});
  }

  static Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;

    return await db.query('reports');
  }
}
