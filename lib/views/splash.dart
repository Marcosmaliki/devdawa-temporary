import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:devdawa/auth/login.dart';
import 'package:devdawa/auth/signup.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/views/home.dart';
import 'package:devdawa/views/waiting_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var base_client = BaseClient();

  bool _fetching = true;
  bool? _logged_in;
  Map<dynamic, dynamic>? user;
  String token = "";

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
        child: AnimatedSplashScreen(
          //nextScreen: Login(),
          nextScreen: WaitingPage(),
          /*nextScreen: _logged_in == false
              ? Login()
              : !_fetching
                  ? HomeScreen(user: user, token: token)
                  : Splash(),*/
          splash: 'assets/icons/pharmacy.png',
          splashTransition: SplashTransition.rotationTransition,
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

  _checkScreen() async {
    final prefs = await SharedPreferences.getInstance();

    String user_uid = prefs.getString("user_uid").toString();

    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/user/$user_uid/get",
        prefs.getString("token").toString());

    if (request_result["status"] == "offline") {
      _showSnackBar("You are offline", Colors.red, Icons.error, Colors.white,
          Colors.white);
    } else if (request_result["status"] == "timeout") {
      _showSnackBar("Request timeout", Colors.yellow, Icons.info, Colors.black,
          Colors.black);
    } else {
      setState(() {
        user = request_result["data"]["data"];
        token = prefs.getString("token").toString();
        _fetching = false;
        _logged_in = prefs.getBool("logged_in");
      });
    }
  }
}
