import 'package:flutter/material.dart';

class AddConditions extends StatefulWidget {
  @override
  _AddConditionsState createState() => _AddConditionsState();
}

class _AddConditionsState extends State<AddConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Add Condition"),
      ),
    );
  }
}
