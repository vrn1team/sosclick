import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import '../models/currentuser.dart';
import '../models/user.dart';
import 'repository.dart';

class UsersDbProvider implements Source, Cache {
  Database db;

  UsersDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "itemsHN.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Users
            (
              id INTEGER PRIMARY KEY,
              fio TEXT,
              phone TEXT,
              email TEXT,           
              relatives BLOB
            )          
          """);
        newDb.execute("""
          CREATE TABLE CurrentUsers
            (
              id INTEGER PRIMARY KEY,
              uniqueid TEXT
            )          
          """);
      },
    );
  }

  Future<User> fetchUser(int id) async {
    final maps = await db.query(
      "Users",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return User.fromDb(maps.first);
    }

    return null;
  }

  Future<int> addUser(User user) {
    return db.insert(
      "Users",
      user.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clearUsers() {
    return db.delete("Users");
  }

  Future<CurrentUser> fetchCurrentUser(String hash) async {
    final maps = await db.query(
      "CurrentUsers",
      columns: null,
      where: "hash = ?",
      whereArgs: [hash],
    );

    if (maps.length > 0) {
      return CurrentUser.fromDb(maps.first);
    }

    return null;
  }

  Future<int> addCurrentUser(CurrentUser currentuser) {
    return db.insert(
      "CurrentUsers",
      currentuser.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clearCurrentUsers() {
    return db.delete("CurrentUsers");
  }
}

final usersDbProvider = UsersDbProvider();
