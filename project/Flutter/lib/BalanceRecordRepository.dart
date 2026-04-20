import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

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
        case 'getDailyBalanceData':
          final args = Map<String, dynamic>.from(call.arguments);
          final year = args['year'] as int;
          final month = args['month'] as int;
          final dailyData = await getDailyBalanceData(year, month);
          print('dart getDailyBalanceData result: $dailyData');
          return dailyData;
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
    final currentMonth = DateFormat('yyyy-MM').format(now);

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

  Future<List<Map<String, dynamic>>> getDailyBalanceData(int year, int month) async {
    print('getDailyBalanceData: $year-$month');
    final db = await database;
    final monthStr = DateFormat('yyyy-MM').format(DateTime(year, month));

    final records = await db.query(
      'balanceRecords',
      where: 'date LIKE ?',
      whereArgs: ['$monthStr%'],
      orderBy: 'date ASC',
    );

    final daysInMonth = DateTime(year, month + 1, 0).day;
    int cumulativeIncome = 0;
    int cumulativeExpenses = 0;

    final List<Map<String, dynamic>> result = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final dayStr = DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));

      for (var record in records) {
        if (record['date'] == dayStr) {
          final amount = record['amount'] as int? ?? 0;
          if (record['type'] == '収入') {
            cumulativeIncome += amount;
          } else if (record['type'] == '支出') {
            cumulativeExpenses += amount;
          }
        }
      }

      result.add({
        'date': dayStr,
        'cumulativeIncome': cumulativeIncome,
        'cumulativeExpenses': cumulativeExpenses,
      });
    }

    return result;
  }

  Future<int> getMonthlyExpenses() async {
    print('getMonthlyExpenses');
    final db = await database;
    final now = DateTime.now();
    final currentMonth = DateFormat('yyyy-MM').format(now);

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