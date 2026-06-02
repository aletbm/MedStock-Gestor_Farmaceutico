import 'package:medstock/domain/entities/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  factory UserDatabaseHelper() => _instance;
  UserDatabaseHelper._internal();

  static Database? _database;
  
  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate:(db, version) async {
        await db.execute('''
        CREATE TABLE users (
          id            INTEGER PRIMARY KEY AUTOINCREMENT,
          name          TEXT    NOT NULL,
          lastname      TEXT    NOT NULL,
          matricula     TEXT    NOT NULL UNIQUE,
          password      TEXT    NOT NULL,
          rol           TEXT    NOT NULL,
          telefono      TEXT    NOT NULL,
          email         TEXT,
          activo        INTEGER NOT NULL DEFAULT 1,
          fechaAlta    TEXT    NOT NULL,
          ultimoAcceso TEXT
        )
      ''');
      },
    );
  }

  Future<int> insertUser(User user) async{
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<User?> findByMatriculaAndPassword(String matricula, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'matricula = ? AND password = ? AND activo = 1',
      whereArgs: [matricula, password],
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User?> findById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
}