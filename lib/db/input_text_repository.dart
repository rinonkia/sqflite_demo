import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/db/db_provider.dart';
import 'package:sqflite_demo/model/input_text.dart';

class InputTextRepository {
  static String table = 'input_text';
  static DBProvider instance = DBProvider.instance;

  static Future<InputText> create(String text) async {
    DateTime now = DateTime.now();
    final Map<String, dynamic> row = {
      'body': text,
      'created_at': now.toString(),
      'updated_at': now.toString(),
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return InputText(
      id: id,
      body: row["body"],
      createdAt: now,
      updatedAt: now,
    );
  }

  static Future<List<InputText>> getAll() async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table ORDER BY updated_at DESC');
    if (rows.isEmpty) return null;

    return rows.map((e) => InputText.fromMap(e)).toList();
  }

  static Future<int> getCount() async {
    final db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  static Future<InputText> single(int id) async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table WHERE id = ?', [id]);
    if (rows.isEmpty) return null;

    return InputText.fromMap(rows.first);
  }

  static Future<int> update({int id, String text}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'body': text,
      'updated_at': now,
    };
    final db = await instance.database;
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
