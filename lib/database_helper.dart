import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Dapatkan database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db'); // Nama database dapat diubah
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 2, // Versi database (disesuaikan untuk migrasi)
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Tambahkan onUpgrade untuk migrasi
    );
  }

  // Membuat tabel baru
  Future<void> _createDB(Database db, int version) async {
    // Tabel menu
    await db.execute('''
      CREATE TABLE menu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        price REAL,
        description TEXT,
        imageUrl TEXT,
        rating REAL
      )
    ''');

    // Tabel user
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        password TEXT NOT NULL
      )
    ''');

    // Tabel admin
    await db.execute('''
      CREATE TABLE admin (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Mengupgrade database saat versi meningkat
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tambahkan tabel user jika belum ada
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          phone TEXT,
          password TEXT NOT NULL
        )
      ''');

      // Tambahkan tabel admin jika belum ada
      await db.execute('''
        CREATE TABLE IF NOT EXISTS admin (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL
        )
      ''');
    }
  }

  // Menutup database
  Future<void> close() async {
    final db = await _database;
    db?.close();
  }

  // ========================= Menu CRUD Operations =========================

  Future<int> insertMenu(Map<String, dynamic> menu) async {
    final db = await database;
    return await db.insert('menu', menu, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getMenuItems() async {
    final db = await database;
    return await db.query('menu');
  }

  Future<int> deleteMenu(int id) async {
    final db = await database;
    return await db.delete('menu', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isMenuExistsByName(String name) async {
    final db = await database;
    final result = await db.query(
      'menu',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  // ========================= User CRUD Operations =========================

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('user');
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'user', // Replace with your actual table name for users
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('user', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('user', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }


  // ========================= Admin CRUD Operations =========================

  Future<int> insertAdmin(Map<String, dynamic> admin) async {
    final db = await database;
    return await db.insert('admin', admin, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAdmins() async {
    final db = await database;
    return await db.query('admin');
  }

  Future<Map<String, dynamic>?> getAdminByEmailAndPassword(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'admin',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Get admin by email
  Future<Map<String, dynamic>?> getAdminByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'admin', // Replace with your actual table name for users
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteAdmin(int id) async {
    final db = await database;
    return await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> logTables() async {
    final db = await database; // Ambil instance database
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("Tables in database: $tables");
  }

}
