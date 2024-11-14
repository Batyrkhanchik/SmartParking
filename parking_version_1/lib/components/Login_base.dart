import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase _instance = UserDatabase._internal();
  Database? _userDatabase;

  factory UserDatabase() {
    return _instance;
  }

  UserDatabase._internal();

  Future<Database> get database async {
    if (_userDatabase != null) return _userDatabase!;
    _userDatabase = await _initializeUserDatabase();
    return _userDatabase!;
  }

  Future<Database> _initializeUserDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_accounts.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'user_accounts',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'user_accounts',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
