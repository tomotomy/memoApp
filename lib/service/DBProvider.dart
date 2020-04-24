import 'dart:io';
import 'package:memo/models/memo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDir = await getApplicationSupportDirectory();
    String path = join(documentsDir.path, 'app,db');

    return await openDatabase(
      path, 
      version: 1, 
      onOpen: (db) async {

      },
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE memos(id INTEGER PRIMARY KEY, contents TEXT)'
        );
      } 
    );
  }

  newMemo(Memo memo) async {
    final db = await database;
    var res = await db.insert('memo', memo.toJson());

    return res;
  }

  getMemos() async {
    final db = await database;
    var res = await db.query('memo');
    List<Memo> memos = res.isNotEmpty ? res.map((memo) => Memo.fromJson(memo)).toList() : [];

    return memos;
  }

  updateMemo(Memo memo) async {
    final db = await database;
    var res = await db.update('memo', memo.toJson(), where: 'id = ?', whereArgs: [memo.id]);

    return res; 
  } 

  deleteNote(int id) async {
     final db = await database;

    db.delete('memo', where: 'id = ?', whereArgs: [id]);
  }
}