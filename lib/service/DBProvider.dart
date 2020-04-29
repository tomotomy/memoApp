import 'dart:io';
import 'package:memo/models/memo.dart';
import 'package:memo/models/note.dart';
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
    String path = join(documentsDir.path, 'app.db');

    return await openDatabase(
      path, 
      version: 1, 
      onOpen: (db) async {

      },
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE memo(id TEXT PRIMARY KEY, noteId TEXT,title TEXT, contents, TEXT, type TEXT, labelColor TEXT)',
        );
        await db.execute(
          'CREATE TABLE note(id TEXT PRIMARY KEY, title TEXT, date TEXT, point INTEGER)'
        );
      } 
    );
  }

  newMemo(Memo memo) async {
    final db = await database;
    var res = await db.insert('memo', memo.toJson());

    return res;
  }

  getMemos(String type, String noteId) async {
    final db = await database;
    var res = await db.query("memo", where: 'type = ? and noteId = ?', whereArgs: [type, noteId]);
    List<Memo> memos = res.isNotEmpty ? res.map((memo) => Memo.fromJson(memo)).toList() : [];

    return memos;
  }

  updateMemo(Memo memo) async {
    final db = await database;
    var res = await db.update('memo', memo.toJson(), where: 'id = ?', whereArgs: [memo.id]);
    return res; 
  } 

  deleteMemo(String id) async {
     final db = await database;

    db.delete('note', where: 'id = ?', whereArgs: [id]);
  }

  newNote(Note note) async {
    final db = await database;
    var res = await db.insert('note', note.toJson());

    return res;
  }

  getNotes() async {
    final db = await database;
    var res = await db.query('note');
    List<Note> notes = res.isNotEmpty ? res.map((note) => Note.fromJson(note)).toList() : [];

    return notes;
  }

  updateNote(Note note) async {
    final db = await database;
    var res = await db.update('note', note.toJson(), where: 'id = ?', whereArgs: [note.id]);

    return res; 
  } 

  deleteNote(String id) async {
     final db = await database;

    db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
  
}

