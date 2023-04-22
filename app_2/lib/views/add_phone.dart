import 'package:flutter/material.dart';
import '../phone.dart';
import '../database_helper.dart';

class AddPhoneView extends StatefulWidget {
  const AddPhoneView({super.key});

  @override
  State<AddPhoneView> createState() => _AddPhoneView();
}

class _AddPhoneView extends State<AddPhoneView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add new phone')),
        body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Enter manufacturer name",
                        labelText: 'Manufacturer'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Enter model name",
                        labelText: 'Model'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Enter OS version",
                        labelText: 'OS version'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Enter website link",
                        labelText: 'Website'),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Website'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Save'),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
