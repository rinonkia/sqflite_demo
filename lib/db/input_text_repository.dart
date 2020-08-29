import 'package:sqflite_demo/db/db_provider.dart';
import 'package:sqflite_demo/model/input_text.dart';

class InputTextRepository {
  static String table = 'input_text';
  static DBProvider instance = DBProvider.instance;

  static Future<InputText> create(String text) async {
    final Map<String, dynamic> row = {
      'body': text,
      'created_at': 'test',
      'updated_at': 'test',
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return InputText(
      id: id,
      body: row["body"],
      createdAt: row["created_at"],
      updatedAt: row["updated_at"],
    );
  }

  static Future<List<InputText>> getAll() async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table ORDER BY updated_at DESC');
    if (rows.isEmpty) return null;

    return rows.map((e) => InputText.fromMap(e)).toList();
  }

  static Future<InputText> single(int id) async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table WHERE id = ?', [id]);
    if (rows.isEmpty) return null;

    return InputText.fromMap(rows.first);
  }

  static Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
