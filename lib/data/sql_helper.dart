import 'dart:io';
import 'package:flutter_student_1318434/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SqlHelper {
  static Database? _db;
  final String colId = 'id';
  final String colName = 'name';
  final String colPhone = 'phoneNumber';
  final String colEmail = 'email';
  final String tableContact = 'tbContact';

  static final SqlHelper _singleton = SqlHelper._internal();
  final int version = 1;
  factory SqlHelper() {
    return _singleton;
  }
  SqlHelper._internal();

  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String dbPath = join(dir.path, 'DbContact_HUYEN.db');
    Database dbContacts =
        await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbContacts;
  }

  Future _createDb(Database db, int version) async {
    String query =
        'CREATE TABLE $tableContact($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colPhone TEXT, $colEmail TEXT)';
    await db.execute(query);
  }

  Future<int> insert(Contact contact) async {
    _db ??= await init();
    int result = await _db!.insert(tableContact, contact.toMap());
    return result;
  }

  Future<int> update(Contact contact) async {
    _db ??= await init();
    int result = await _db!.update(tableContact, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  Future<int> delete(Contact contact) async {
    _db ??= await init();
    int result = await _db!
        .delete(tableContact, where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  Future<List<Contact>> getList() async {
    _db ??= await init();

    List<Contact> contacts = [];

    List<Map<String, dynamic>>? contactList =
        await _db?.query(tableContact, orderBy: colName);

    contactList?.forEach((element) {
      contacts.add(Contact.fromMap(element));
    });
    return contacts;
  }

  Future<List<Contact>> filters(String key) async {
    _db ??= await init();
    List<Contact> contacts = [];

    List<Map<String, dynamic>>? contactList = await _db?.query(tableContact,
        orderBy: colName, where: '$colName like ?', whereArgs: ["%$key%"]);

    contactList?.forEach((element) {
      contacts.add(Contact.fromMap(element));
    });
    return contacts;
  }
}
