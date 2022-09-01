import 'package:badges/badges.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonDrugs extends StatefulWidget {
  @override
  _CommonDrugsState createState() => _CommonDrugsState();
}

class _CommonDrugsState extends State<CommonDrugs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Common drugs"),
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        child: Center(
          child: Text("Common drugs screen"),
        ),
      ),
    );
  }
}
