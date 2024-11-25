import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      desc TEXT,
      login TEXT,
      password TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) 
    """);

    await database.execute("""
      CREATE TABLE data2(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        term TIMESTAMP,
        value TEXT,
        desc TEXT,
        paid INTEGER NOT NULL DEFAULT 0, 
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database.db',
      version: 3,
      onCreate: (sql.Database db, int version) async {
        await createTables(db);
      },
    );
  }

  static Future<int> createData(
      String item, String? desc, String? pass, String? login) async {
    final db = await SQLHelper.db();
    final data = {
      'title': item,
      'desc': desc,
      'login': login,
      'password': pass,
    };

    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    final data = await db.query('data', orderBy: 'id');
    return data;
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    final data =
        await db.query('data', where: 'id = ?', whereArgs: [id], limit: 1);
    return data;
  }

  static Future<int> updateData(
      int id, String item, String? desc, String? pass, String? login) async {
    final db = await SQLHelper.db();
    final data = {
      'title': item,
      'login': login,
      'desc': desc,
      'createdAt': DateTime.now().toString(),
      'password': pass,
    };
    final result =
        await db.update('data', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }

  static Future<List<Map<String, dynamic>>> seeData(int id) async {
    final db = await SQLHelper.db();
    final data = await db.query('data', where: 'id = ?', whereArgs: [id]);
    return data;
  }

  // CRUD 2
  static Future<int> addData2(
      String name, String? term, String? value, String? desc) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'term': DateTime.now().toString(),
      'value': value,
      'desc': desc, 
      'paid': 0, // Adicione esta linha
    };
    final id = await db.insert('data2', data);
    return id;
  }

  static Future<void> resetPayments() async {
    final db = await SQLHelper.db();
    await db.update('data2', {'paid': 0});
  }

  static Future<List<Map<String, dynamic>>> getAllDataFromData2() async {
    final db = await SQLHelper.db();
    final data = await db.query('data2', orderBy: 'id');
    return data;
  }

  static Future<List<Map<String, dynamic>>> getSingleData2(int id) async {
    final db = await SQLHelper.db();
    final data =
        await db.query('data2', where: 'id = ?', whereArgs: [id], limit: 1);
    return data;
  }

  static Future<int> updateData2(int id, String name, String? term,
      String? value, String? desc, bool paid) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'term': term,
      'desc': desc,
      'value': value,
      'createdAt': DateTime.now().toString(),
      'paid': paid ? 1 : 0, // Adicione esta linha
    };
    final result =
        await db.update('data2', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteDataFromData2(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('data2', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}
