import 'package:flutter/material.dart';

class MenuFavs extends StatefulWidget {
  @override
  _MenuFavsState createState() => _MenuFavsState();
}

class _MenuFavsState extends State<MenuFavs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Text("No Favourites"),
      ),
    );
  }
}
