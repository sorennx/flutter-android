import 'package:flutter/material.dart';
import '../../models/phone.dart';
import '../../config/database_helper.dart';

class InspectPhoneView extends StatefulWidget {
  const InspectPhoneView({super.key, required this.phone});
  final Phone phone;

  @override
  State<InspectPhoneView> createState() => _InspectPhoneView();
}

class _InspectPhoneView extends State<InspectPhoneView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.phone.model)),
      body: const Center(child: Text('test')),
    );
  }
}
