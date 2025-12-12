import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/victim_profile.dart';

class DBService {
  static Database? _db;
  static const _dbName = 'first_responder.db';

  static Future<void> init() async {
    if (_db != null && _db!.isOpen) return;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    _db = await openDatabase(path, version: 1, onCreate: (db, ver) async {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT,
          role TEXT,
          enabled INTEGER DEFAULT 1
        )
      ''');
      await db.execute('''
        CREATE TABLE victims (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          victim_id TEXT UNIQUE,
          name TEXT,
          phone TEXT,
          medical_notes TEXT,
          allergies TEXT,
          medications TEXT,
          mock_fingerprint_token TEXT
        )
      ''');

      await db.insert('users', {'username':'admin','password':'admin','role':'admin','enabled':1});
      await db.insert('users', {'username':'paramedic01','password':'1234','role':'paramedic','enabled':1});
      await db.insert('users', {'username':'user01','password':'1234','role':'general','enabled':1});
      await db.insert('victims', {
        'victim_id':'VICTIM-001',
        'name':'Demo Victim',
        'phone':'9999999999',
        'medical_notes':'Diabetic',
        'allergies':'Penicillin',
        'medications':'Metformin',
        'mock_fingerprint_token':'finger_abc123'
      });
    });
  }

  static Future<Database> _getDb() async {
    if (_db == null || !_db!.isOpen) await init();
    return _db!;
  }

  // Users
  static Future<int> insertUser(UserModel u) async {
    final db = await _getDb();
    return db.insert('users', u.toMap());
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await _getDb();
    final rows = await db.query('users');
    return rows.map((r) => UserModel.fromMap(r)).toList();
  }

  static Future<int> deleteUser(int id) async {
    final db = await _getDb();
    return db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Victims
  static Future<int> insertVictim(VictimProfile v) async {
    final db = await _getDb();
    return db.insert('victims', v.toMap());
  }

  static Future<List<VictimProfile>> getAllVictims() async {
    final db = await _getDb();
    final rows = await db.query('victims');
    return rows.map((r) => VictimProfile.fromMap(r)).toList();
  }

  static Future<VictimProfile?> getVictimByFingerprint(String token) async {
    final db = await _getDb();
    final rows = await db.query('victims', where: 'mock_fingerprint_token = ?', whereArgs: [token]);
    if (rows.isEmpty) return null;
    return VictimProfile.fromMap(rows.first);
  }

  static Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }
}
