import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'StoryModel.dart';
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
          "context TEXT,"
          "status INTEGER"
          ")");
    });
  }

  newStory(Story newStory) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Stories");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Stories (id,heading,context,status)"
        " VALUES (?,?,?,?)",
        [id, newStory.heading, newStory.context, newStory.status]);
    return raw;
  }

  changeStatus(Story story) async {
    final db = await database;
    Story status = Story(
        id: story.id,
        heading: story.heading,
        context: story.context,
        status: !story.status);
    var res = await db.update("Stories", status.toMap(),
        where: "id = ?", whereArgs: [story.id]);
    return res;
  }

  updateStory(Story newStory) async {
    final db = await database;
    print('updating id of:'+ newStory.id.toString());
    var res = await db.update("Stories", newStory.toMap(),
        where: "id = ?", whereArgs: [newStory.id]);
    return res;
  }

  getStory(int id) async {
    final db = await database;
    var res = await db.query("Stories", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Story.fromMap(res.first) : null;
  }

  Future<List<Story>> getBlockedStories() async {
    final db = await database;

    print("works");
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

  deleteStories(int id) async {
    final db = await database;
    return db.delete("Stories", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Stories");
  }
  check0() async {
    final db = await database;
    int count =  Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Stories'));

    print(count);
    if (count == 0) {
      print("0");
      return "hello";
    }
    else {
      print("1");
      return "goodbye";
    }
  }
}
