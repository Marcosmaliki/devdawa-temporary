import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBusiness extends StatefulWidget {
  final Map user;
  final String token;
  final String seller_id;

  AddBusiness(
      {required this.user, required this.token, required this.seller_id});

  @override
  _AddBusinessState createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final IconButtonController _loadingBtnController = IconButtonController();
  var base_client = BaseClient();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regController = TextEditingController();
  final TextEditingController _kraController = TextEditingController();
  final TextEditingController _primaryController = TextEditingController();
  final TextEditingController _secondaryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Add a business"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10.0)),
                Text(
                  'Business & seller information',
                  style: TextStyle(color: AppColors.black, fontSize: 18.0),
                ),
                const Padding(padding: EdgeInsets.only(top: 5.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Business name",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _regController,
                    decoration: InputDecoration(
                      labelText: "Registration number",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _kraController,
                    decoration: InputDecoration(
                      labelText: "KRA pin",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10.0)),
                Text(
                  'Business contact information',
                  style: TextStyle(color: AppColors.black, fontSize: 18.0),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _primaryController,
                    decoration: InputDecoration(
                      labelText: "Primary phone",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _secondaryController,
                    decoration: InputDecoration(
                      labelText: "Secondary phone",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _typeController,
                    decoration: InputDecoration(
                      labelText: "Business type",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.0)),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email address",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
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
                        'Submit',
                        style: GoogleFonts.openSans().copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      iconData: Icons.login,
                      onPressed: () {
                        if (_nameController.text.isNotEmpty &&
                            _regController.text.isNotEmpty &&
                            _kraController.text.isNotEmpty &&
                            _primaryController.text.isNotEmpty &&
                            _secondaryController.text.isNotEmpty &&
                            _typeController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty) {
                          _createBusiness();
                        } else {
                          _loadingBtnController.reset();
                          _showSnackBar(
                              "All fields are mandatory",
                              Colors.amber,
                              Icons.warning,
                              Colors.black,
                              Colors.black);
                        }
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

  _showSnackBar(message, color, icon, iconsColor, textColor) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: iconsColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            message,
            style: TextStyle(color: iconsColor),
          )
        ],
      ),
      backgroundColor: color,
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _isValidEmail(email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  _createBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "sellerId": prefs.getString("client_id"),
      "businessName": _nameController.text,
      "regNo": _regController.text,
      "kraPin": _kraController.text,
      "primaryPhone": _primaryController.text,
      "secondaryPhone": _secondaryController.text,
      "type": _typeController.text,
      "email": _emailController.text,
      "averageRating": "0"
    };

    if (_isValidEmail(_emailController.text)) {
      var request_result = await BaseClient.postRequest(
          base_client.base_url + "/business/add", data);

      _loadingBtnController.reset();

      if (request_result["data"]["success"]) {
        _showSnackBar(request_result["data"]["message"].toString(),
            Colors.green, Icons.done, Colors.white, Colors.white);

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: SellerHome(
                  user: widget.user,
                  token: widget.token,
                ),
                inheritTheme: true,
                ctx: context),
          );
        });
      } else {
        _showSnackBar("Something went wrong", Colors.red, Icons.error,
            Colors.white, Colors.white);
      }
    } else {
      _showSnackBar("Not a valid email address", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    //print(request_result);
  }
}
