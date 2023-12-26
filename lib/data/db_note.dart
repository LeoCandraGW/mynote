// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:my_note/data/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelperBar {
  DatabaseHelperBar._privateConstructor();
  static final DatabaseHelperBar instance = DatabaseHelperBar._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyNote1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE MyNote1(
          id INTEGER PRIMARY KEY,
          Judul TEXT,
          Isi TEXT,
          Date TEXT
      )
      ''');
  }

  Future<List<Note>> getNote() async {
    Database db = await instance.database;
    var note = await db.query('MyNote1', orderBy: 'id');
    List<Note> barcodeList = note.isNotEmpty
        ? note.map((c) => Note.fromMap(c)).toList()
        : [];
    return barcodeList;
  }

  Future<Note?> detailNote(int id) async {
  Database db = await instance.database;
  var note = await db.query('MyNote1', where: "id = ?", whereArgs: [id]);
  return note.isNotEmpty ? Note.fromMap(note.first) : null;
}


  Future<int> add(Note note) async {
    Database db = await instance.database;
    return await db.insert('MyNote1', note.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('MyNote1', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.update('MyNote1', note.toMap(),
        where: "id = ?", whereArgs: [note.id]);
  }
  
  
}