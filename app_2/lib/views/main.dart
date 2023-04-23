import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../config/database_helper.dart';
import 'phone/add_phone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const MyHomePage(title: 'Phone browser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum MenuItem { deleteAll, addExamplePhones }

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _navigateToAddPhone(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddPhoneView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        PopupMenuButton<MenuItem>(
            onSelected: (value) {
              switch (value) {
                case MenuItem.deleteAll:
                  DatabaseHelper.instance.removeAll('phones');
                  break;
                case MenuItem.addExamplePhones:
                  DatabaseHelper.instance.addExamplePhones();
                  break;
                default:
                  break;
              }
              setState(() {});
            },
            itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: MenuItem.deleteAll, child: Text('Remove all')),
                  const PopupMenuItem(
                      value: MenuItem.addExamplePhones,
                      child: Text('Add examples'))
                ])
      ]),
      body: Center(
          child: FutureBuilder<List<Phone>>(
              future: DatabaseHelper.instance.getPhones(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Phone>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading data..'));
                }
                return snapshot.data!.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                            const Expanded(
                              child:
                                  Center(child: Text('No phones available.')),
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: FloatingActionButton(
                                        child: const Icon(Icons.add),
                                        onPressed: () {
                                          _navigateToAddPhone(context);
                                        })))
                          ])
                    : Column(children: [
                        Expanded(
                          child: ListView(
                              children: snapshot.data!.map((phone) {
                            return Center(
                              child: ListTile(
                                  title: Text(
                                      "${phone.producent} ${phone.model}")),
                            );
                          }).toList()),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FloatingActionButton(
                                    child: const Icon(Icons.add),
                                    onPressed: () {
                                      _navigateToAddPhone(context);
                                    })))
                      ]);
              })),
    );
  }
}
