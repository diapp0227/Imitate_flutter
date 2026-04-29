import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'DatabaseProvider.dart';

class CategoryRepository {
  static const platform = MethodChannel('CategoryRepository');
  final DatabaseProvider databaseProvider;

  CategoryRepository(this.databaseProvider);

  Future<Database> get database => databaseProvider.database;

  void registerMethodHandler() {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'getCategories':
          final args = Map<String, dynamic>.from(call.arguments);
          final type = args['type'] as String;
          final list = await getCategories(type);
          print('dart getCategories result: $list');
          return list;
        case 'addCategory':
          final args = Map<String, dynamic>.from(call.arguments);
          final id = await addCategory(
            args['name'] as String,
            args['type'] as String,
          );
          print('dart addCategory id: $id');
          return id;
        case 'updateCategory':
          final args = Map<String, dynamic>.from(call.arguments);
          final count = await updateCategory(
            args['id'] as int,
            args['name'] as String,
          );
          print('dart updateCategory count: $count');
          return count;
        case 'deleteCategory':
          final args = Map<String, dynamic>.from(call.arguments);
          final count = await deleteCategory(args['id'] as int);
          print('dart deleteCategory count: $count');
          return count;
        default:
          throw PlatformException(code: 'Unimplemented');
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCategories(String type) async {
    final db = await database;
    return await db.query(
      'categories',
      where: 'type = ? AND is_deleted = 0',
      whereArgs: [type],
      orderBy: 'id ASC',
    );
  }

  Future<int> addCategory(String name, String type) async {
    final db = await database;
    return await db.insert('categories', {
      'name': name,
      'type': type,
      'is_deleted': 0,
    });
  }

  Future<int> updateCategory(int id, String name) async {
    final db = await database;
    return await db.update(
      'categories',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 論理削除
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.update(
      'categories',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
