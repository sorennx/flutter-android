import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/phone.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstuctor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstuctor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE phones(id INTEGER PRIMARY KEY AUTOINCREMENT, producent TEXT, model TEXT, os_version TEXT, website TEXT)
  ''');
  }

  // General use methods

  // Deletes all objects from given table
  Future<int> removeAll(String tableName) async {
    Database db = await instance.database;
    return await db.delete(tableName);
  }

  // Inserts an object that was previously mapped to a given table
  Future<int> insertObject(
      String tableName, Map<String, dynamic> objectMap) async {
    Database db = await instance.database;
    return await db.insert(tableName, objectMap);
  }

  // Deletes an object of given id, from a given table
  Future<int> deleteObject(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Updates an object that was previously mapped, in a given table
  Future<int> updateObject(
      String tableName, Map<String, dynamic> objectMap) async {
        print(objectMap['id']);
    int id = objectMap['id'];
    Database db = await instance.database;
    return await db
        .update(tableName, objectMap, where: 'id = ?', whereArgs: [id]);
  }

  // Model specific methods

  // Phone

  Future<List<Phone>> getPhones() async {
    Database db = await instance.database;
    var phones = await db.query('phones');
    List<Phone> phoneList =
        phones.isNotEmpty ? phones.map((p) => Phone.fromMap(p)).toList() : [];
    return phoneList;
  }

  Future<int> addPhone(Phone phone) async {
    Database db = await instance.database;
    return await db.insert('phones', phone.toMap());
  }

  Future<int> removePhone(int id) async {
    Database db = await instance.database;
    return await db.delete('phones', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addExamplePhones() async {
    var phones = const [
      Phone(
        producent: 'Samsung',
        model: 'S22 Ultra',
        osVersion: '13',
        website: 'samsung.com',
      ),
      Phone(
        producent: 'Samsung',
        model: 'S23 Ultra',
        osVersion: '13',
        website: 'samsung.com',
      ),
      Phone(
        producent: 'Apple',
        model: 'IPhone 13+',
        osVersion: '13',
        website: 'apple.com',
      )
    ];

    for (var phone in phones) {
      addPhone(phone);
    }
  }
}
