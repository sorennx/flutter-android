import 'package:flutter/material.dart';
import 'phone.dart';
import 'database_helper.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Phone>>(
              future: DatabaseHelper.instance.getPhones(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Phone>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading data..'));
                }
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No phones available.'))
                    : ListView(
                        children: snapshot.data!.map((phone) {
                        return Center(
                          child: ListTile(title: Text("${phone.producent} ${phone.model}")),
                        );
                      }).toList());
              })),
    );
  }
}
