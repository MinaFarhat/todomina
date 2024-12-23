// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/task.dart';

class DBHelper {
  static Database? _db;
  static  const int _virsion = 1;
  static  const String _tableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      debugPrint("DB not null");
      return;
    } else {
      try {
        String path = "${await getDatabasesPath()}task.db";
        debugPrint("in database");
        _db = await openDatabase(path, version: _virsion,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
            'CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'remind INTEGER, repeat STRING, '
              'startTime STRING, endTime STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)'
              );
        });
      } catch (e) {
        // ignore: duplicate_ignore
        // ignore: avoid_print
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    try {
       return await _db!.insert(_tableName,task!.toJson());
    } catch (e) {
      print("we are here");
      return 9999999;
    }
   
  }

  static Future<int> delete(Task task) async {
    print("delete");
    return await _db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]);
  }
   static Future<int> deleteAll() async {
    print("delete All");
    return await _db!.delete(_tableName);
  }
   static Future<List<Map<String,dynamic>>> query() async {
    print("query");
    return await _db!.query(_tableName);
    
  }

  static Future<int> update(int id) async {
    print("update");
    return await _db!.rawUpdate('''
  UPDATE tasks
  SET isCompleted = ?
  WHERE id = ?
  ''', [1, id]);
  }
}
