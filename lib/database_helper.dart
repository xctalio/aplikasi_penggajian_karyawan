import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('penggajian.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final pathStr = path.join(dbPath, filePath);

    return await openDatabase(
      pathStr,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE karyawan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idKaryawan TEXT NOT NULL,
        nama TEXT NOT NULL,
        jabatan TEXT NOT NULL,
        gajiPokok REAL NOT NULL,
        tunjangan REAL NOT NULL,
        potongan REAL NOT NULL,
        totalGaji REAL NOT NULL
      )
    ''');
    print('Database created successfully');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS karyawan');
      await _createDB(db, newVersion);
      print('Database upgraded from v$oldVersion to v$newVersion');
    }
  }

  Future<int> insertKaryawan(Map<String, dynamic> karyawan) async {
    try {
      final db = await instance.database;
      final result = await db.insert('karyawan', karyawan);
      print('Data inserted: $karyawan');
      return result;
    } catch (e) {
      print('Insert error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllKaryawan() async {
    try {
      final db = await instance.database;
      final result = await db.query('karyawan', orderBy: 'id DESC');
      print('Retrieved ${result.length} records');
      return result;
    } catch (e) {
      print('Query error: $e');
      return [];
    }
  }

  Future<int> updateKaryawan(Map<String, dynamic> karyawan) async {
    try {
      final db = await instance.database;
      final result = await db.update(
        'karyawan',
        karyawan,
        where: 'id = ?',
        whereArgs: [karyawan['id']],
      );
      print('Data updated: $karyawan');
      return result;
    } catch (e) {
      print('Update error: $e');
      rethrow;
    }
  }

  Future<int> deleteKaryawan(int id) async {
    try {
      final db = await instance.database;
      final result = await db.delete(
        'karyawan',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Data deleted: ID $id');
      return result;
    } catch (e) {
      print('Delete error: $e');
      rethrow;
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}