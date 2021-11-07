import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/ob/noteOb.dart';
class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db = null;
  DatabaseHelper._instance();
  String noteTable = "note_table";
  String coId = "id";
  String colTitle = "title";
  String colDate = "date";
  String colPriority = "priority";
  String colStatus = "status";
  Future<Database?> get db async{
    if(_db == null){
      _db = await initDb();
    }
    return _db;
  }
  Future<Database> initDb()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "todo_list.db";
    final todoListDB = await openDatabase(
      path, version: 1,onCreate: _createDb
    );
    return todoListDB;
  }
  void _createDb(Database db, int version)async{
    await db.execute(
      'CREATE TABLE $noteTable($coId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)'
    );
  }
  Future<List<Map<String,dynamic>>> getNoteMapList() async{
    Database? db = await this.db;
    final List<Map<String,dynamic>> result = await db!.query(noteTable);
    return result;
  }
  Future<List<Note>> getNoteList()async{
    final List<Map<String,dynamic>> noteMapList = await getNoteMapList();
    final List<Note> noteList = [];
    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));
    });
    noteList.sort((noteA,noteB)=>noteA.date!.compareTo(noteB.date!));
    return noteList;
  }
  Future<int> insertNote(Note note)async{
    Database? db = await this.db;
    final int result = await db!.insert(
      noteTable,
      note.toMap(),
    );
    return result;
  }
  Future<int> updateNote(Note note)async{
    Database? db = await this.db;
    final int result = await db!.update(
      noteTable,
      note.toMap(),
      where: '$coId = ?',
      whereArgs: [note.id]
    );
    return result;
  }
  Future<int> deleteNote(int id)async{
    Database? db = await this.db;
    final int result = await db!.delete(
      noteTable,
      where: '$coId = ?',
      whereArgs: [id]
    );
    return result;
  }



}