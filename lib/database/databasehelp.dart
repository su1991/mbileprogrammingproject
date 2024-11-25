import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper
{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async
  {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async
  {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Hediaty.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users table
    await db.execute
      ('''
      CREATE TABLE Users
       (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        preferences TEXT
      )
    ''');

    // Create Events table
    await db.execute
      ('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        location TEXT,
        description TEXT,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES Users (id)
      )
    ''');

    // Create Gifts table
    await db.execute
      ('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        eventId INTEGER,
        FOREIGN KEY (eventId) REFERENCES Events (id)
      )
    ''');

    // Create Friends table
    await db.execute('''
      CREATE TABLE Friends (
        userId INTEGER,
        friendId INTEGER,
        PRIMARY KEY (userId, friendId),
        FOREIGN KEY (userId) REFERENCES Users (id),
        FOREIGN KEY (friendId) REFERENCES Users (id)
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return db.insert('Users', user);
  }
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return db.query('Users');
  }
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return db.update('Users', user, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return db.insert('Events', event);
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await database;
    return db.query('Events');
  }

  Future<int> updateEvent(int id, Map<String, dynamic> event) async {
    final db = await database;
    return db.update('Events', event, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteEvent(int id) async {
    final db = await database;
    return db.delete('Events', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    return db.insert('Gifts', gift);
  }
  Future<List<Map<String, dynamic>>> getGifts() async {
    final db = await database;
    return db.query('gifts');
  }
  Future<int> updategift(int id, Map<String, dynamic> gift) async {
    final db = await database;
    return db.update('gifts', gift, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deletegift(int id) async {
    final db = await database;
    return db.delete('gifts', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> insertFriend(Map<String, dynamic> friend) async {
    final db = await database;
    return db.insert('friends', friend);
  }
  Future<List<Map<String, dynamic>>> getFriend() async {
    final db = await database;
    return db.query('Friend');
  }
  Future<int> updateFriend(int id, Map<String, dynamic> Friend) async {
    final db = await database;
    return db.update('Friends', Friend, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteFriend(int id) async {
    final db = await database;
    return db.delete('Friend', where: 'id = ?', whereArgs: [id]);
  }

}
