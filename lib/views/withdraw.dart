import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdraw extends StatefulWidget {
  final Map user;
  final String token;
  final String walletId;

  Withdraw({required this.user, required this.token, required this.walletId});
  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  bool _obscureText = true;

  final TextEditingController _withdrawController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final IconButtonController _loadingBtnController = IconButtonController();

  bool _email_valid = false;

  var base_client = BaseClient();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Withdraw"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textInputAction: TextInputAction.next,
              controller: _withdrawController,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                prefixIcon: Icon(
                  Icons.money,
                  color: AppColors.green,
                ),
              ),
            ),
            const SizedBox(
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
                    'Withdraw',
                    style: GoogleFonts.openSans().copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  iconData: Icons.login,
                  onPressed: () {
                    if (_withdrawController.text.isNotEmpty) {
                      _withdrawAmount(
                        _withdrawController.text,
                      );
                    } else {
                      _loadingBtnController.reset();
                      _showSnackBar("Enter amount", Colors.amber, Icons.warning,
                          Colors.black, Colors.black);
                    }
                  },
                  successIcon: Icons.check_circle_outline,
                  controller: _loadingBtnController,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _withdrawAmount(amount) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "amount": _withdrawController.text,
      "refId": prefs.getString("client_id")
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/wallet/user/get", data);

    if (request_result["response"] == 200) {
      _loadingBtnController.reset();
    }
  }
}
