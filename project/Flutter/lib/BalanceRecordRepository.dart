import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'DatabaseProvider.dart';

class BalanceRecordRepository {
  static const platform = MethodChannel('BalanceRecordRepository');
  final DatabaseProvider databaseProvider;

  BalanceRecordRepository(this.databaseProvider);

  Future<Database> get database => databaseProvider.database;

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
        case 'getAvailableYearMonths':
          final yearMonths = await getAvailableYearMonths();
          print('dart getAvailableYearMonths result: $yearMonths');
          return yearMonths;
        default:
          throw PlatformException(code: 'Unimplemented');
      }
    });
  }

  Future<void> insert(Map<String, dynamic> args) async {
    print('insert: $args');
    final db = await database;
    try {
      final id = await db.insert(
        'balanceRecords',
        {
          'type': args['type'],
          'income_category_id': args['incomeCategoryId'],
          'expense_category_id': args['expenseCategoryId'],
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
    return await db.rawQuery('''
      SELECT
        b.id,
        b.type,
        b.income_category_id,
        b.expense_category_id,
        ic.name AS income_category,
        ec.name AS expense_category,
        b.amount,
        b.memo,
        b.date,
        b.created_at,
        b.game_flag
      FROM balanceRecords b
      LEFT JOIN categories ic ON b.income_category_id = ic.id
      LEFT JOIN categories ec ON b.expense_category_id = ec.id
    ''');
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

  Future<List<String>> getAvailableYearMonths() async {
    print('getAvailableYearMonths');
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT substr(date, 1, 7) as yearMonth FROM balanceRecords ORDER BY yearMonth ASC',
    );
    return result.map((row) => row['yearMonth'] as String).toList();
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
