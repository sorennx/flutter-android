import 'package:flutter/material.dart';
import '../phone.dart';
import '../database_helper.dart';

class AddPhoneView extends StatefulWidget {
  const AddPhoneView({super.key});

  @override
  State<AddPhoneView> createState() => _AddPhoneView();
}

class _AddPhoneView extends State<AddPhoneView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add new phone')),
        body: const Center(
          child: Text("Yo"),
        ));
  }
}
