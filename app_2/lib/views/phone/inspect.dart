import 'package:flutter/material.dart';
import '../../models/phone.dart';
import '../../config/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import './docs.dart';

class InspectPhoneView extends StatefulWidget {
  const InspectPhoneView(
      {super.key, required this.phone, required this.onPhoneUpdated});
  final Phone phone;
  final Function() onPhoneUpdated;
  @override
  State<InspectPhoneView> createState() => _InspectPhoneView();
}

class _InspectPhoneView extends State<InspectPhoneView> {
  final _formKey = GlobalKey<FormState>();
  final manufacturerFieldController = TextEditingController();
  final modelFieldController = TextEditingController();
  final osVersionFieldController = TextEditingController();
  final websiteFieldController = TextEditingController();

  Future<void> updatePhone() async {
    var phone = Phone(
        id: widget.phone.id,
        producent: manufacturerFieldController.text,
        model: modelFieldController.text,
        osVersion: osVersionFieldController.text,
        website: websiteFieldController.text);

    DatabaseHelper.instance.updateObject('phones', phone.toMap());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    osVersionFieldController.dispose();
    websiteFieldController.dispose();
    super.dispose();
  }

  void loadPhoneData() {
    manufacturerFieldController.text = widget.phone.producent;
    modelFieldController.text = widget.phone.model;
    osVersionFieldController.text = widget.phone.osVersion;
    websiteFieldController.text = widget.phone.website;
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);
    print(uri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Cannot launch URL";
    }
  }

  Future<void> _navigateToDocs(BuildContext context, String downloadLink) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhoneDocsView(downloadLink: downloadLink)));
  }

  @override
  Widget build(BuildContext context) {
    loadPhoneData();
    return Scaffold(
        appBar: AppBar(title: Text(widget.phone.model)),
        body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: manufacturerFieldController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a manufacturer name.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Enter a manufacturer name",
                            labelText: 'Manufacturer',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(0, 64, 124, 214),
                                  width: 2),
                            ),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: modelFieldController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a model name.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Enter a model name",
                            labelText: 'Model',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(0, 64, 124, 214),
                                  width: 2),
                            ),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: osVersionFieldController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter OS version.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Enter OS version",
                            labelText: 'OS version',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                            ),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: websiteFieldController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a website link.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Enter a website link',
                            labelText: 'Website link',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(0, 64, 124, 214),
                                  width: 2),
                            ),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Cancel')),
                        ElevatedButton(
                            onPressed: () {
                              _launchURL(widget.phone.website);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade300),
                            child: const Text('Website')),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              updatePhone();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Phone has been successfully updated.'),
                                  backgroundColor:
                                      Color.fromRGBO(56, 142, 60, 1),
                                ),
                              );
                              widget.onPhoneUpdated();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _navigateToDocs(context, widget.phone.website);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade300),
                          child: const Text('Docs'),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
