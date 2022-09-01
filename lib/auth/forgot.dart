import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController _phonecontroller = TextEditingController();
  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "Forgot password",
          style: GoogleFonts.openSans().copyWith(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Type registered email address below",
              style: GoogleFonts.openSans()
                  .copyWith(color: Colors.grey[400], fontSize: 13),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _phonecontroller,
              decoration: InputDecoration(
                hintText: 'Email address',
                prefixIcon: Icon(
                  Icons.email,
                  color: AppColors.green,
                ),
              ),
            ),
            SizedBox(
              height: 10,
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
                    'Submit',
                    style: GoogleFonts.openSans().copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  iconData: Icons.login,
                  onPressed: () {
                    if (_phonecontroller.text.isNotEmpty) {
                      _changePassword();
                    }
                  },
                  successIcon: Icons.delete,
                  controller: _loadingBtnController,
                ),
              ),
            ),
          ],
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

  _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {"email": _phonecontroller.text};

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/user/auth/password/change", data);

    print(request_result);

    _loadingBtnController.reset();

    if (!request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }
  }
}
