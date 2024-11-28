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

    // Tabel user (modifikasi untuk menambah kolom 'role')
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        password TEXT NOT NULL,
        role TEXT DEFAULT 'user'  -- Kolom role yang baru
      )
    ''');
  }

  // Mengupgrade database saat versi meningkat
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Modifikasi tabel user untuk menambah kolom role
      await db.execute('''
        ALTER TABLE user ADD COLUMN role TEXT DEFAULT 'user';
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
    return await db.insert(
        'menu', menu, conflictAlgorithm: ConflictAlgorithm.replace);
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
    return await db.insert(
        'user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    var result = await db.query('user');
    return List<Map<String, dynamic>>.from(
        result); // Make it explicitly mutable
  }


  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email,
      String password) async {
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
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update user role
  Future<int> updateUserRole(int id, String role) async {
    final db = await database;
    return await db.update(
      'user',
      {'role': role},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fungsi untuk request menjadi admin (update role menjadi pending)
  Future<void> requestAdmin(int userId) async {
    await updateUserRole(userId, 'pending'); // Mengubah role menjadi 'pending'
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

  // ========================= User Status Operations =========================

  // Fungsi untuk mengubah status user menjadi 'admin'
  Future<int> promoteUserToAdmin(int userId) async {
    final db = await database;
    return await db.update(
      'user',
      {'role': 'admin'}, // Mengubah role menjadi admin
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Fungsi untuk mengubah status admin menjadi 'user'
  Future<int> demoteAdminToUser(int adminId) async {
    final db = await database;
    return await db.update(
      'user',
      {'role': 'user'}, // Mengubah role menjadi user
      where: 'id = ?',
      whereArgs: [adminId],
    );
  }

  // Fungsi untuk mengubah status user yang sedang 'pending' menjadi 'user'
  Future<int> setUserRoleFromPendingToUser(int userId) async {
    final db = await database;
    return await db.update(
      'user',
      {'role': 'user'}, // Mengubah role dari pending ke user
      where: 'id = ? AND role = ?',
      whereArgs: [
        userId,
        'pending'
      ], // Pastikan hanya mengubah yang role-nya 'pending'
    );
  }
}