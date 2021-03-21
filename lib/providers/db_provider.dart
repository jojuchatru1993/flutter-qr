import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr2/models/scan_model.dart';
export 'package:qr2/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          type TEXT,
          value TEXT
        )
      ''');
    });
  }

  Future<int> newScanRaw(ScanModel newScan) async {
    final id = newScan.id;
    final type = newScan.type;
    final value = newScan.value;

    final db = await database;

    final request = await db.rawInsert('''
      INSERT INTO Scans(id, type, value)
        VALUES($id, '$type', '$value')
    ''');

    return request;
  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await database;

    final request = await db.insert('Scans', newScan.toJson());

    return request;
  }

  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final request = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return request.isNotEmpty ? ScanModel.fromJson(request.first) : null;
  }

  Future<List<ScanModel>> getScanAll() async {
    final db = await database;
    final request = await db.query('Scans');

    return request.isNotEmpty
        ? request.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future<List<ScanModel>> getScanByType(String type) async {
    final db = await database;
    final request = await db.rawQuery('''
      SELECT * FROM Scans WHERE type = '$type'
    ''');

    return request.isNotEmpty
        ? request.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future<int> updateScanById(ScanModel updateScan) async {
    final db = await database;
    final request = await db.update('Scans', updateScan.toJson(),
        where: 'id = ?', whereArgs: [updateScan.id]);

    return request;
  }

  Future<int> deleteScanById(int id) async {
    final db = await database;
    final request = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return request;
  }

  Future<int> deleteScan() async {
    final db = await database;
    final request = await db.delete('Scans');

    return request;
  }
}
