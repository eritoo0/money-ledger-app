import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Mydb {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initializeDb();
    }
    return _db!;
  }

  Future<Database> _initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'notes.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    // Creating the 'users' table
    batch.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL
      )
    ''');

    // Creating the 'transactions' table with a foreign key
    batch.execute('''
      CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      moneygiven DECIMAL(10, 2) NOT NULL,
      description TEXT, 
      transaction_date DATETIME NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    await batch.commit();
    print("Successfully created the database and tables");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE transactions ADD COLUMN description TEXT");
    }
  }

  Future<List<Map<String, dynamic>>> readData(String sql,
      [List<dynamic>? args]) async {
    try {
      Database db = await this.db;
      return await db.rawQuery(sql, args);
    } catch (e) {
      print('Error reading data: $e');
      rethrow;
    }
  }

  Future<int> insertData(String sql, List<dynamic> args) async {
    try {
      Database db = await this.db;
      return await db.rawInsert(sql, args);
    } catch (e) {
      print('Error inserting data: $e');
      rethrow;
    }
  }

  Future<int> updateData(String sql, [List<dynamic>? args]) async {
    Database db = await this.db;
    return await db.rawUpdate(sql, args);
  }

  Future<int> deleteData(String sql, [List<dynamic>? args]) async {
    Database db = await this.db;
    return await db.rawDelete(sql, args);
  }

  Future<void> mydeleteDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'notes.db');
    await deleteDatabase(path);
  }
}
