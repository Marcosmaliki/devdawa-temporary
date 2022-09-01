import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/base_client.dart';

class MakePayment extends StatefulWidget {
  final Map user;
  final String order_id;

  MakePayment({required this.user, required this.order_id});

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  bool _ordering = false;

  var base_client = BaseClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "Make payment",
          style: GoogleFonts.openSans().copyWith(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset(
                "assets/images/lipa.png",
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                _makePayment(widget.order_id);
                /*Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CheckOutScreen(),
                                  inheritTheme: true,
                                  ctx: context),
                            );*/
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  width: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.green,
                  ),
                  child: Center(
                    child: _ordering
                        ? Text(
                            "Processing...",
                            style: TextStyle(color: AppColors.white),
                          )
                        : Text(
                            "Proceed",
                            //"Check Out",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                  )),
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

  _makePayment(String order_id) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "orderId": order_id,
      "paymentMode": "6609d95d-df17-11ec-8e4b-18dbf20f0b96"
    };

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/order/pay",
        data,
        prefs.getString("token").toString());

    if (request_result["data"]["success"]) {
      _showSnackBar(
          "Order placed", Colors.green, Icons.done, Colors.white, Colors.white);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: HomeScreen(
                user: widget.user,
                token: prefs.getString("token").toString(),
              ),
              inheritTheme: true,
              ctx: context),
        );
      });
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }
  }
}
