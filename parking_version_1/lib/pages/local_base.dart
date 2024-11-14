import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  Database? _database;

  factory LocalDatabase() {
    return _instance;
  }

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'parking.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE parking_slots (
            id INTEGER PRIMARY KEY,
            type TEXT,
            status TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertSlot(int id, String type, String status) async {
    final db = await database;
    await db.insert(
      'parking_slots',
      {'id': id, 'type': type, 'status': status},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSlots(String type) async {
    final db = await database;
    return await db.query('parking_slots', where: 'type = ?', whereArgs: [type]);
  }
}
