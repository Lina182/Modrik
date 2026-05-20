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
      version: 3,
      onCreate: (db, version) async {
        // REPORTS TABLE
        await db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT,
            title TEXT,
            type TEXT
          )
        ''');
        // DISEASE TRANSLATIONS TABLE
        await db.execute('''
          CREATE TABLE disease_translations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            english_name TEXT UNIQUE,
            arabic_translation TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ADD TITLE COLUMN
        try {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN title TEXT',
          );
        } catch (e) {}
        // ADD TYPE COLUMN
        try {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN type TEXT',
          );
        } catch (e) {}
        // CREATE TRANSLATIONS TABLE
        try {
          await db.execute('''
            CREATE TABLE disease_translations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              english_name TEXT UNIQUE,
              arabic_translation TEXT
            )
          ''');
        } catch (e) {}
      },
    );
    return _database!;
  }
  // SAVE REPORT
  static Future<void> saveReport({
    required List<Map<String, dynamic>> items,
    required String title,
    required String type,
  }) async {
    final db = await database;
    String data = jsonEncode(items);
    await db.insert(
      'reports',
      {
        'data': data,
        'title': title,
        'type': type,
      },
    );
  }
  // GET REPORTS
  static Future<List<Map<String, dynamic>>> getReports() async {

    final db = await database;

    return await db.query('reports');
  }
  // SAVE DISEASE TRANSLATION
  static Future<void> saveDiseaseTranslation({
    required String englishName,
    required String arabicTranslation,
  }) async {
    final db = await database;
    await db.insert(
      'disease_translations',
      {
        'english_name':
            englishName
                .trim()
                .toLowerCase(),
        'arabic_translation':
            arabicTranslation,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }
  // GET DISEASE TRANSLATION
  static Future<String?> getDiseaseTranslation(
    String englishName,
  ) async {
    final db = await database;
    final result = await db.query(
      'disease_translations',
      where: 'english_name = ?',
      whereArgs: [
        englishName
            .trim()
            .toLowerCase(),
      ],
    );
    if (result.isNotEmpty) {
      return result.first[
          'arabic_translation'] as String;
    }
    return null;
  }
}