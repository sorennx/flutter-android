import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'models/phone.dart';
import 'config/database_helper.dart';
import 'views/phone/add.dart';
import 'views/phone/inspect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
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

  Future<void> _navigateToInspectPhone(
      BuildContext context, Phone phone) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InspectPhoneView(
                phone: phone, onPhoneUpdated: updatePhoneList)));
  }

  Future<List<Phone>> _phoneListFuture = DatabaseHelper.instance.getPhones();

  Future<List<Phone>> fetchPhoneList() async {
    return DatabaseHelper.instance.getPhones();
  }

  void updatePhoneList() {
    setState(() {
      _phoneListFuture = fetchPhoneList();
    });
  }

  Future<List<Phone>> removePhoneFromList(Phone phoneToRemove) async {
    List<Phone> phoneList = await _phoneListFuture;
    phoneList.remove(phoneToRemove);
    return Future.value(phoneList);
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
                  updatePhoneList();
                  break;
                case MenuItem.addExamplePhones:
                  DatabaseHelper.instance.addExamplePhones();
                  updatePhoneList();
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
              future: _phoneListFuture,
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
                                child: Dismissible(
                                    background: Container(color: Colors.red),
                                    key: Key(phone.id.toString()),
                                    onDismissed: (direction) => {
                                          setState(() {
                                            DatabaseHelper.instance
                                                .removePhone(phone.id!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${phone.producent} ${phone.model} has been successfully deleted.'),
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        56, 142, 60, 1),
                                              ),
                                            );
                                            removePhoneFromList(phone);
                                          })
                                        },
                                    child: InkWell(
                                      onTap: () {
                                        _navigateToInspectPhone(context, phone);
                                      },
                                      child: ListTile(
                                          title: Text(
                                              "${phone.producent} ${phone.model}")),
                                    )));
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
