import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Android Lab'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTranslations().then((value) {});
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradesCountController = TextEditingController();

  bool isFormValid = false;
  bool _showSubmitButton = false;
  void _submitButtonVisibilityHandler() {
    setState(() {
      if (!isFormValid) {
        isFormValid = _formKey.currentState!.validate();
      }
      print(isFormValid);
    });
  }

  XmlDocument translations = XmlDocument();
  Future<XmlDocument> getTranslations() async {
    String xmlString = await loadAsset();
    translations = XmlDocument.parse(xmlString);
    return translations;
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/en_en.xml');
  }

  final user_lang = "en-en";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<XmlDocument>(
      future: getTranslations(),
      // The builder function will be called when the Future completes
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // The Future has completed, so build the widget
          // print(snapshot.data!.findAllElements("button_enter_grades_amount_label").first.text);
          return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
              ),
              body: Form(
                  key: _formKey,
                  onChanged: () => setState(() =>
                      _showSubmitButton = _formKey.currentState!.validate()),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translations
                                        .findAllElements(
                                            'button_enter_name_text')
                                        .first
                                        .text;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: snapshot.data!
                                      .findAllElements(
                                          "button_enter_name_label")
                                      .first
                                      .text,
                                  hintText: snapshot.data!
                                      .findAllElements("button_enter_name_hint")
                                      .first
                                      .text,
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return snapshot.data!
                                        .findAllElements(
                                            "button_enter_lastname_text")
                                        .first
                                        .text;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: snapshot.data!
                                      .findAllElements(
                                          "button_enter_lastname_label")
                                      .first
                                      .text,
                                  hintText: snapshot.data!
                                      .findAllElements(
                                          "button_enter_lastname_hint")
                                      .first
                                      .text,
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                controller: _gradesCountController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return snapshot.data!
                                        .findAllElements(
                                            "button_enter_grades_amount_text")
                                        .first
                                        .text;
                                  }
                                  if (int.parse(value) < 5 ||
                                      int.parse(value) > 15) {
                                    return snapshot.data!
                                        .findAllElements(
                                            "button_enter_grades_amount_error")
                                        .first
                                        .text;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: snapshot.data!
                                      .findAllElements(
                                          "button_enter_grades_amount_label")
                                      .first
                                      .text,
                                  hintText: snapshot.data!
                                      .findAllElements(
                                          "button_enter_grades_amount_hint")
                                      .first
                                      .text,
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Visibility(
                              visible: _showSubmitButton,
                              child: ElevatedButton(
                                child: const Text('GRADES'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      // print("xdd: $.length}");
                                      return GradesView(
                                          gradesCount:
                                              int.parse(_gradesCountController.text),
                                          classes: snapshot.data!
                                              .findAllElements("class"));
                                    }));
                                  }
                                },
                              ))
                        ],
                      ))));
        } else if (snapshot.hasError) {
          // An error occurred, so show an error message
          return Text('Error: ${snapshot.error}');
        }
        // Otherwise, show a loading indicator
        return CircularProgressIndicator();
      },
    );
  }
}

class GradesView extends StatefulWidget {
  const GradesView(
      {super.key, required this.gradesCount, required this.classes});

  // final String title;
  final gradesCount;
  final classes;

  @override
  State<GradesView> createState() => _GradesView(gradesCount, classes);
}

class _GradesView extends State<GradesView> {
  int gradesCount;
  Iterable<XmlElement> classes;
  _GradesView(this.gradesCount, this.classes);
  List<int?> selections = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3];

  nodesToArray(nodes) {
    var arr = [];
    for (var node in nodes) {
      arr.add(node.text);
    }
    return arr;
  }

  setupSelections() {
    selections = [];
    int defaultValue = 3;
    for (int i = 0; i < gradesCount; i++) {
      selections.add(defaultValue);
    }
  }

  createRadioButtonGroupsv2() {
    
    List<Widget> rows = [];
    for (int i = 0; i < gradesCount; i++) {
      Row row = Row(children: [
        const Text('2'),
        Radio<int>(
          value: 2,
          groupValue: selections[i],
          onChanged: (int? value) {
            setState(() {
              selections[i] = value;
            });
          },
        ),
        const Text('3'),
        Radio<int>(
          value: 3,
          groupValue: selections[i],
          onChanged: (int? value) {
            setState(() {
              selections[i] = value;
            });
          },
        ),
        const Text('4'),
        Radio<int>(
          value: 4,
          groupValue: selections[i],
          onChanged: (int? value) {
            setState(() {
              selections[i] = value;
            });
          },
        ),
        const Text('5'),
        Radio<int>(
          value: 5,
          groupValue: selections[i],
          onChanged: (int? value) {
            setState(() {
              selections[i] = value;
            });
            print(selections);
          },
        ),
      ]);
      rows.add(row);
    }

    return Column(children: rows);
  }

  @override
  Widget build(BuildContext context) {
    var classesList = nodesToArray(classes);
    
    int sum = 0;

    return Scaffold(
        appBar: AppBar(
          title: Text('My View'),
        ),
        body: Center(
          child: createRadioButtonGroupsv2(),
        ));
  }
}
