import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_by_me/Models/student.dart';

class DB_helper {
  static DB_helper db_helper;
  static Database _db;
  static String id = "id";
  static String Name = "Name";
  static String Desc = "Desc";
  static String Dt = "Dt";
  static String Stat = "Stat";
  static const String TABLE = 'Student';
  static const String DB_NAME = 'Students.db';

  //create instance
  DB_helper._createInstance();

// constuctor
  factory DB_helper() {
    if (db_helper == null) {
      db_helper = DB_helper._createInstance();
    }
    return db_helper;
  }

  //Functions

  //Test if db == null
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  //Initiale the db
  Future<Database> initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String path = join(dir.path, DB_NAME);

    var db = await openDatabase(path, version: 1, onCreate: _OnCreate);

    return db;
  }

  //Create the Table
  void _OnCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($id INTEGER PRIMARY KEY AUTOINCREMENT , $Name TEXT , $Desc TEXT, $Dt TEXT , $Stat INTEGER  )");
  }

  //Insert
  Future<int> insertUser(Students st) async {
    var dbClient = await db;

    int x = await dbClient.insert(TABLE, st.tomap());
    return x;
  }

//Update

  Future<int> update(Students st) async {
    var dbClient = await db;

    var x = await dbClient
        .update(TABLE, st.tomap(), where: "$id = ?", whereArgs: [st.id]);
  }

  //Delete

  Future<int> delete(int ID) async {
    var dbClient = await db;

    var result =
        await dbClient.delete(TABLE, where: "$id = ?", whereArgs: [ID]);
    return result;
  }

  // getStudents

  Future<List<Students>> getStudents() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE);
    List<Students> st = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        st.add(Students.fromMap(maps[i]));
      }
    }
    return st;
  }

  Future<List<Students>> getStudent(String name) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .rawQuery("select * from $TABLE where $Name LIKE '%${name}%'");
    List<Students> st = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        st.add(Students.fromMap(maps[i]));
      }
    }
    return st;
  }
}
