import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'phone.dart';
// Define a function that inserts dogs into the database

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE phones(id INTEGER PRIMARY KEY AUTOINCREMENT, producent TEXT, model TEXT, os_version TEXT, website TEXT)');
    },
    version: 1,
  );
  Future<void> insertPhone(Phone phone) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'phones',
      phone.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Create a Dog and add it to the dogs table
  var p = const Phone(
    id: 1,
    producent: 'Samsung',
    model: 'S22 Ultra',
    osVersion: '13',
    website: 'samsung.com',
  );

  await insertPhone(p);

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Phone>> phones() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('phones');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Phone(
        id: maps[i]['id'],
        producent: maps[i]['producent'],
        model: maps[i]['model'],
        osVersion: maps[i]['os_version'],
        website: maps[i]['website'],
      );
    });
  }

  print(await phones());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Android part 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        children: <Widget>[Text("Yo"), Text("aha")],
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
