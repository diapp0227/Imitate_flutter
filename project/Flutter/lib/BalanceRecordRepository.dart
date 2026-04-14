import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BalanceRecordRepository {
  static const platform = MethodChannel('BalanceRecordRepository');
  Database? db;

  // DBを取得
  Future<Database> get database async {
    if (db != null) return db!;

    db = await openDB();
    return db!;
  }

  void registerMethodHandler() {
    platform.setMethodCallHandler((call) async {
      // ネイティブから呼び出されたメソッドの実装
      switch (call.method) {
        case 'insert':
          insert(Map<String, dynamic>.from(call.arguments));
          return null;
        case 'selectAll':
          final list = await selectAll();
          print('dart selectAll result: $list');
          return list;
        case 'getMonthlyIncome':
          final income = await getMonthlyIncome();
          print('dart getMonthlyIncome result: $income');
          return income;
        case 'getMonthlyExpenses':
          final expenses = await getMonthlyExpenses();
          print('dart getMonthlyExpenses result: $expenses');
          return expenses;
        default:
          throw PlatformException(code: 'Unimplemented');
      }
    });
  }

  Future<Database> openDB() async {
    print('openDB');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Balance.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE balanceRecords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        income_category TEXT,
        expense_category TEXT,
        amount INTEGER,
        memo TEXT,
        date TEXT,
        created_at TEXT,
        game_flag INTEGER
        );
      ''');
      },
    );
  }

  Future<void> insert(Map<String, dynamic> args) async {
    print('insert: $args');
    final db = await database;
    try {
      final id = await db.insert(
        'balanceRecords',
        {
          'type': args['type'],
          'income_category': args['incomeCategory'],
          'expense_category': args['expenseCategory'],
          'amount': args['amount'],
          'memo': args['memo'],
          'date': args['date'],
          'created_at': args['createdAt'],
          'game_flag': args['gameFlag'] ? 1 : 0,
        },
      );
      print('inserted id: $id');
    } catch (e, stack) {
      print('insert error: $e');
      print(stack);
    }
  }

  Future<List<Map<String, dynamic>>> selectAll() async {
    print('selectAll');
    final db = await database;
    // print(await db.rawQuery('SELECT COUNT(*) FROM balanceRecords'));
    return await db.query('balanceRecords');
  }

  Future<int> getMonthlyIncome() async {
    print('getMonthlyIncome');
    final db = await database;
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final records = await db.query(
      'balanceRecords',
      where: 'date LIKE ? AND type = ?',
      whereArgs: ['$currentMonth%', '収入'],
    );

    int total = 0;
    for (var record in records) {
      final amount = record['amount'] as int? ?? 0;
      total += amount;
    }

    return total;
  }

  Future<int> getMonthlyExpenses() async {
    print('getMonthlyExpenses');
    final db = await database;
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final records = await db.query(
      'balanceRecords',
      where: 'date LIKE ? AND type = ?',
      whereArgs: ['$currentMonth%', '支出'],
    );

    int total = 0;
    for (var record in records) {
      final amount = record['amount'] as int? ?? 0;
      total += amount;
    }

    return total;
  }
}