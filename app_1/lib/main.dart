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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  Future getTranslations() async {
    // File file = File('assets/en_en.xml');
    String xmlString = await loadAsset();
    translations = XmlDocument.parse(xmlString);
    // print(translations);
    // return await XmlDocument.parse(xmlString);
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/en_en.xml');
  }

  final user_lang = "en-en";

  
  // 
  // XmlDocument a = XmlDocument();

  // String to = document.findAllElements('to').first.text;
  // String from = document.findAllElements('from').first.text;
  // String heading = document.findAllElements('heading').first.text;
  // String body = document.findAllElements('body').first.text;
  // XmlDocument translations = XmlDocument();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // translations = getTranslations();
    // Future<XmlDocument> translationsFuture = getTranslations();
    // XmlDocument translations = await translationsFuture; // Allowed
    // translations = getTranslations() as XmlDocument;
    // print(translations);
    getTranslations();
    // print(translations.findAllElements("button_enter_grades_amount_label").first.text);
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Form(
            key: _formKey,
            onChanged: () => setState(
                () => _showSubmitButton = _formKey.currentState!.validate()),
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
                                  .findAllElements('button_enter_name_text').first.text;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Please enter your name',
                            border: OutlineInputBorder(),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your lastname';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Lastname',
                            hintText: 'Please enter your lastname',
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
                              return 'Please enter amount of your grades';
                            }
                            if (int.parse(value) < 5 || int.parse(value) > 15) {
                              return 'The amount of grades needs to be in range [5,15]';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Grades count',
                            hintText: 'Please enter amount of your grades',
                            border: OutlineInputBorder(),
                          ),
                        )),
                    Visibility(
                        visible: _showSubmitButton,
                        child: ElevatedButton(
                          child: const Text('OCENY'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print(_nameController.text);
                            }
                          },
                        ))
                  ],
                ))));
  }
}
