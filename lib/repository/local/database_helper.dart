import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Mở hoặc tạo cơ sở dữ liệu
    final path = await getDatabasesPath();
    return openDatabase(
      '$path/my_database.db',
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng "account"
        await db.execute('''
          CREATE TABLE account (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            subscription_id INTEGER,
            email TEXT,
            password TEXT,
            is_verified INTEGER
          )
        ''');
        // Tạo bảng "book" và các bảng khác nếu cần
      },
    );
  }
}
