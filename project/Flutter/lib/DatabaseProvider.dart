import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const int _databaseVersion = 1;
  static const String _databaseName = 'Balance.db';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    print('openDB');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedCategories(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // 開発中のためテーブルを作り直す
        await db.execute('DROP TABLE IF EXISTS balanceRecords');
        await db.execute('DROP TABLE IF EXISTS categories');
        await _createTables(db);
        await _seedCategories(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE balanceRecords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        income_category_id INTEGER,
        expense_category_id INTEGER,
        amount INTEGER,
        memo TEXT,
        date TEXT,
        created_at TEXT,
        game_flag INTEGER
      );
    ''');
  }

  Future<void> _seedCategories(Database db) async {
    const incomeNames = ['給料', 'その他'];
    const expenseNames = ['食費', '外食費', '日用品', '交通費', '衣服', '趣味', 'その他'];

    for (final name in incomeNames) {
      await db.insert('categories', {
        'name': name,
        'type': 'income',
        'is_deleted': 0,
      });
    }
    for (final name in expenseNames) {
      await db.insert('categories', {
        'name': name,
        'type': 'expense',
        'is_deleted': 0,
      });
    }
  }
}
