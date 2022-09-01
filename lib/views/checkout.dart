import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final IconButtonController _loadingBtnController = IconButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "CheckOut",
          style: GoogleFonts.openSans().copyWith(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Shipping Information",
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "CheckOut field 1",
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorHeight: 20,
                  autofocus: false,
                  //controller: TextEditingController(text: "Initial Text here"),
                  decoration: InputDecoration(
                    labelText: 'Enter item 1',
                    hintText: "Enter item 1",
                    prefixIcon: Icon(Icons.star),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: AppColors.green, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "CheckOut field 2",
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorHeight: 20,
                  autofocus: false,
                  //controller: TextEditingController(text: "Initial Text here"),
                  decoration: InputDecoration(
                    labelText: 'Enter item 2',
                    hintText: "Enter item 2",
                    prefixIcon: Icon(Icons.star),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: AppColors.green, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "CheckOut field 3",
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorHeight: 20,
                  autofocus: false,
                  //controller: TextEditingController(text: "Initial Text here"),
                  decoration: InputDecoration(
                    labelText: 'Enter item 3',
                    hintText: "Enter item 3",
                    prefixIcon: Icon(Icons.star),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: AppColors.green, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "CheckOut field 4",
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorHeight: 20,
                  autofocus: false,
                  //controller: TextEditingController(text: "Initial Text here"),
                  decoration: InputDecoration(
                    labelText: 'Enter item 4',
                    hintText: "Enter item 4",
                    prefixIcon: Icon(Icons.star),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: AppColors.green, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "CheckOut field 5",
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  cursorHeight: 20,
                  autofocus: false,
                  //controller: TextEditingController(text: "Initial Text here"),
                  decoration: InputDecoration(
                    labelText: 'Enter item 5',
                    hintText: "Enter item 5",
                    prefixIcon: Icon(Icons.star),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: AppColors.green, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: IconLoadingButton(
                      color: AppColors.green,
                      iconColor: Colors.white,
                      valueColor: AppColors.green,
                      errorColor: const Color(0xffe0333c),
                      successColor: Colors.blue,
                      elevation: 1,
                      child: Text(
                        'Finish',
                        style: GoogleFonts.openSans().copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      iconData: Icons.check_circle_outline,
                      onPressed: () {
                        doSomething();
                      },
                      successIcon: Icons.check_circle_outline,
                      controller: _loadingBtnController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  doSomething() async {
    Future.delayed(const Duration(seconds: 1), () {
      _loadingBtnController.error();
      Future.delayed(const Duration(seconds: 1), () {
        _loadingBtnController.reset();
      });
    });
  }
}
