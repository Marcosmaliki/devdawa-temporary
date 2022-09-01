import 'package:flutter/material.dart';

class Prescriptions extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;

  Prescriptions({
    required this.user,
    required this.token,
    required this.business_id,
  });

  @override
  _PrescriptionsState createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
