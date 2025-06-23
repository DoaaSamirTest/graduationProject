import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicine.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medicine_robot.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        time TEXT NOT NULL,
        taken INTEGER DEFAULT 0,
        location TEXT
      )
    ''');

    // إدخال بيانات أولية
    await db.insert(
      'medicines',
      Medicine(name: 'بنادول', time: '09:00', location: 'A1').toMap(),
    );

    await db.insert(
      'medicines',
      Medicine(name: 'فيتامين سي', time: '13:30', location: 'B2').toMap(),
    );

    await db.insert(
      'medicines',
      Medicine(name: 'ضغط', time: '20:00', location: 'C3').toMap(),
    );
  }

  Future<List<Medicine>> getMedicines() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicines');
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<int> insertMedicine(Medicine medicine) async {
    Database db = await database;
    return await db.insert('medicines', medicine.toMap());
  }

  Future<int> updateMedicine(Medicine medicine) async {
    Database db = await database;
    return await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> deleteMedicine(int id) async {
    Database db = await database;
    return await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }

  /// Gets all medicine names from the database
  Future<List<String>> getMedicineNames() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      columns: ['name'],
    );
    return List.generate(maps.length, (i) => maps[i]['name'] as String);
  }

  /// Gets a medicine by name
  Future<Medicine?> getMedicineByName(String name) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return Medicine.fromMap(maps.first);
    }
    return null;
  }
}
