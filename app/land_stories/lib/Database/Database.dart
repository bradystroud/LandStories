import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Models.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Stories ("
          "id INTEGER PRIMARY KEY,"
          "heading TEXT,"
          "context TEXT"
          ");");
      await db.execute("CREATE TABLE Tasks ("
          "id INTEGER PRIMARY KEY,"
          "heading TEXT,"
          "context TEXT,"
          "due INTEGER,"
          "status INTEGER"
          ");");
      await db.execute("CREATE TABLE Changes ("
          "id INTEGER PRIMARY KEY,"
          "storyid INTEGER,"
          "datetime INTEGER,"
          "newValue TEXT,"
          "oldValue TEXT"
          ");");
    });
  }

  newChange(Change change) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Changes");
    int id = table.first["id"];
    if (id == null) { //Don't know why i need this... dont need it on any other tables but it makes it work so i need it.
      id = 1;
    }
    var insert = await db.rawInsert(
        "INSERT Into Changes (id,storyid,datetime,newValue,oldValue)"
        " VALUES (?,?,?,?,?)",
        [
          id,
          change.storyid,
          change.datetime,
          change.newValue,
          change.oldValue
        ]);
    return insert;
  }

  newStory(Story newStory) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Stories");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Stories (id,heading,context)"
        " VALUES (?,?,?)",
        [id, newStory.heading, newStory.context]);
    return raw;
  }

  newTask(Task newTask) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Tasks");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Tasks (id,heading,context,due,status)"
        " VALUES (?,?,?,?,?)",
        [
          id,
          newTask.heading,
          newTask.context,
          newTask.due,
          newTask.status,
        ]);
    return raw;
  }

  changeStatus(Task task) async {
    final db = await database;
    Task status = Task(
        id: task.id,
        heading: task.heading,
        context: task.context,
        due: task.due,
        status: !task.status);
    var res = await db.update(
      "Tasks",
      status.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
    return res;
  }

  updateStory(Story newStory) async {
    final db = await database;
    print('updating id of:' + newStory.id.toString());
    var res = await db.update("Stories", newStory.toMap(),
        where: "id = ?", whereArgs: [newStory.id]);
    return res;
  }

  updateTask(Task newTask) async {
    final db = await database;
    print('updating id of:' + newTask.id.toString());
    var res = await db.update("Tasks", newTask.toMap(),
        where: "id = ?", whereArgs: [newTask.id]);
    return res;
  }

  getStory(int id) async {
    final db = await database;
    var res = await db.query("Stories", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Story.fromMap(res.first) : null;
  }

  getTask(int id) async {
    final db = await database;
    var res = await db.query("Tasks", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Task.fromMap(res.first) : null;
  }

  Future<List<Story>> getBlockedStories() async {
    final db = await database;
    // var res = await db.rawQuery("SELECT * FROM Story WHERE blocked=1");
    var res = await db.query("Stories", where: "status = ? ", whereArgs: [1]);

    List<Story> list =
        res.isNotEmpty ? res.map((c) => Story.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Story>> getAllStories() async {
    final db = await database;
    var res = await db.query("Stories");
    List<Story> list =
        res.isNotEmpty ? res.map((c) => Story.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    var res = await db.query("Tasks");
    List<Task> list =
        res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  deleteStories(int id) async {
    final db = await database;
    return db.delete("Stories", where: "id = ?", whereArgs: [id]);
  }

  deleteTasks(int id) async {
    final db = await database;
    return db.delete("Tasks", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    for (int i = 0; i < 100; i++) { //Inbuilt delete all is broken. using this loop as a temporary fix.
      db.delete("Stories", where: "id = ?", whereArgs: [i]);
      db.delete("Tasks", where: "id = ?", whereArgs: [i]);
    }
  }
}
