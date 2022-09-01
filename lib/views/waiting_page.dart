import 'package:devdawa/auth/login.dart';
import 'package:devdawa/deliverer/deliverer_home.dart';
import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingPage extends StatefulWidget {
  /*final Map user;
  final String token;

  WaitingPage({required this.user, required this.token});*/

  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  bool _fetching = true;
  bool? _logged_in;
  Map user = {};
  String token = "";
  var base_client = BaseClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _checkScreen() async {
    final prefs = await SharedPreferences.getInstance();

    //print("Login status " + prefs.getBool("logged_in").toString());

    String user_uid = prefs.getString("user_uid").toString();

    if (prefs.getBool("logged_in") == null ||
        prefs.getBool("logged_in") == false) {
      Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Login(),
            inheritTheme: true,
            ctx: context),
      );
    } else {
      var request_result = await BaseClient.getRequestAuth(
          base_client.base_url + "/user/$user_uid/get",
          prefs.getString("token"));

      if (request_result["data"]["message"] == "Unauthenticated.") {
        /*if (request_result["data"]["response"] == 401) {*/
        prefs.setBool("logged_in", false).then((value) => {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: Login(),
                    inheritTheme: true,
                    ctx: context),
              )
            });
      } else {
        if (prefs.getString("type") == "seller") {
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: SellerHome(
                  user: request_result["data"]["data"],
                  token: prefs.getString("token").toString(),
                ),
                inheritTheme: true,
                ctx: context),
          );
        } else if (prefs.getString("type") == "client") {
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: HomeScreen(
                  user: request_result["data"]["data"],
                  token: prefs.getString("token").toString(),
                ),
                inheritTheme: true,
                ctx: context),
          );
        } else if (prefs.getString("type") == "deliverer") {
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: DelivererHome(
                  user: request_result["data"]["data"],
                  token: prefs.getString("token").toString(),
                ),
                inheritTheme: true,
                ctx: context),
          );
        }
      }
    }
  }
}
