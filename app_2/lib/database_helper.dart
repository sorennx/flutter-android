import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'phone.dart';

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
}
