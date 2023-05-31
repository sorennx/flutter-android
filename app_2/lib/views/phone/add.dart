import 'package:flutter/material.dart';
import '../../models/phone.dart';
import '../../config/database_helper.dart';

class AddPhoneView extends StatefulWidget {
  final PhoneAddedCallback onPhoneAdded;
  const AddPhoneView({super.key, required this.onPhoneAdded});
  

  @override
  State<AddPhoneView> createState() => _AddPhoneView();
}
typedef PhoneAddedCallback = void Function(Phone phone);

class _AddPhoneView extends State<AddPhoneView> {
  final _formKey = GlobalKey<FormState>();
  final manufacturerFieldController = TextEditingController();
  final modelFieldController = TextEditingController();
  final osVersionFieldController = TextEditingController();
  final websiteFieldController = TextEditingController();
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    osVersionFieldController.dispose();
    websiteFieldController.dispose();
    super.dispose();
  }

  Future<void> savePhone() async {
    var phone = Phone(
        producent: manufacturerFieldController.text,
        model: modelFieldController.text,
        osVersion: osVersionFieldController.text,
        website: websiteFieldController.text);

    DatabaseHelper.instance.addPhone(phone);
  }

  Phone savePhone2() {
        var phone = Phone(
        producent: manufacturerFieldController.text,
        model: modelFieldController.text,
        osVersion: osVersionFieldController.text,
        website: websiteFieldController.text);

        return phone;
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add a new phone')),
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
                            
                            if (_formKey.currentState!.validate()) {
                              // savePhone();
                              var phone = savePhone2();
                              widget.onPhoneAdded(phone);
                              setState(() {
                                
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Phone has been successfully added.'),
                                  backgroundColor:
                                      Color.fromRGBO(56, 142, 60, 1),
                                ),
                              );
                              Navigator.pop(context, phone);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
