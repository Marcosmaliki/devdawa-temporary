import 'package:devdawa/auth/forgot.dart';
import 'package:devdawa/auth/signup.dart';
import 'package:devdawa/deliverer/deliverer_home.dart';
import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/base_client.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final IconButtonController _loadingBtnController = IconButtonController();

  bool _email_valid = false;

  var base_client = BaseClient();

  doSomething() async {
    Future.delayed(const Duration(seconds: 1), () {
      _loadingBtnController.error();
      Future.delayed(const Duration(seconds: 1), () {
        _loadingBtnController.reset();
      });
    });
  }

  _goHome(data, token) {
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: HomeScreen(
            user: data,
            token: token,
          ),
          inheritTheme: true,
          ctx: context),
    );
  }

  _goSellerHome(data, token) {
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SellerHome(
            user: data,
            token: token,
          ),
          inheritTheme: true,
          ctx: context),
    );
  }

  _goDeliveryHome(data, token) {
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: DelivererHome(
            user: data,
            token: token,
          ),
          inheritTheme: true,
          ctx: context),
    );
  }

  _handleRemeberme() {}

  _isValidEmail(email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  _loginUser(email, password) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {"email": email, "password": password};

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/user/auth/login", data);

    /*print(request_result);
    print(request_result["data"]["user"]["roles"].substring(2, 5));*/

    if (request_result["status"] == "offline") {
      _loadingBtnController.reset();
      _showSnackBar("No internet connection", Colors.red, Icons.error,
          Colors.white, Colors.white);
    } else {
      if (request_result["response"] == 200) {
        if (request_result["data"]["success"]) {
          _loadingBtnController.reset();

          if (request_result["data"]["user"]["roles"].substring(2, 5) ==
              "sel") {
            prefs.setString("type", "seller").then((value) => {
                  prefs.setBool("logged_in", true).then((value) {
                    prefs
                        .setString("client_id",
                            request_result["data"]["user"]["user_seller"]["id"])
                        .then((value) {
                      prefs
                          .setString(
                              "token", request_result["data"]["access_token"])
                          .then((value) {
                        prefs
                            .setString("user_uid",
                                request_result["data"]["user"]["id"])
                            .then((value) => _goSellerHome(
                                request_result["data"]["user"],
                                request_result["data"]["access_token"]));
                      });
                    });
                  })
                });
          } else if (request_result["data"]["user"]["roles"].substring(2, 5) ==
              "cli") {
            prefs.setString("type", "client").then((value) => {
                  prefs.setBool("logged_in", true).then((value) {
                    prefs
                        .setString("client_id",
                            request_result["data"]["user"]["user_client"]["id"])
                        .then((value) {
                      prefs
                          .setString(
                              "token", request_result["data"]["access_token"])
                          .then((value) {
                        prefs
                            .setString("user_uid",
                                request_result["data"]["user"]["id"])
                            .then((value) => _goHome(
                                request_result["data"]["user"],
                                request_result["data"]["access_token"]));
                      });
                    });
                  })
                });
          } else if (request_result["data"]["user"]["roles"].substring(2, 5) ==
              "del") {
            prefs.setString("type", "deliverer").then((value) => {
                  prefs.setBool("logged_in", true).then((value) {
                    prefs
                        .setString(
                            "client_id",
                            request_result["data"]["user"]["user_deliverer"]
                                ["id"])
                        .then((value) {
                      prefs
                          .setString(
                              "token", request_result["data"]["access_token"])
                          .then((value) {
                        prefs
                            .setString("user_uid",
                                request_result["data"]["user"]["id"])
                            .then((value) => _goDeliveryHome(
                                request_result["data"]["user"],
                                request_result["data"]["access_token"]));
                      });
                    });
                  })
                });
          }
        } else {
          _showSnackBar(request_result["data"]["message"], Colors.red,
              Icons.error, Colors.white, Colors.white);
        }
      } else {
        _loadingBtnController.error();
        Future.delayed(const Duration(seconds: 1), () {
          _loadingBtnController.reset();
          _showSnackBar(request_result["data"]["message"], Colors.red,
              Icons.error, Colors.white, Colors.white);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_mobile.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      /*AppColors.pink,
                        Colors.pinkAccent,
                        Colors.deepOrange*/
                      AppColors.green,
                      Colors.greenAccent,
                      Colors.green.shade900
                    ])),
                    child: Center(
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/pharmacy.png",
                              height: 80,
                              width: 80,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Dawasap",
                              style: GoogleFonts.openSans().copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 300,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 30, bottom: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Please Login",
                            /*style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),*/
                            style: GoogleFonts.openSans().copyWith(
                                fontWeight: FontWeight.w600,
                                //color: Colors.white,
                                fontSize: 25),
                          ),
                          Row(
                            children: [
                              Text(
                                "Don't have an account yet?",
                                style: GoogleFonts.openSans().copyWith(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SignUp(),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: Text(
                                  "Create one here",
                                  style: GoogleFonts.openSans().copyWith(
                                      color: Colors.green,
                                      fontSize: 13,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Type registered email address below",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: _emailcontroller,
                            onChanged: (email) {
                              if (_isValidEmail(email)) {
                                setState(() {
                                  _email_valid = true;
                                });
                              } else {
                                setState(() {
                                  _email_valid = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Email address',
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: AppColors.green,
                                ),
                                suffixIcon: !_email_valid
                                    ? Icon(
                                        Icons.close,
                                        color: Colors.grey[600],
                                      )
                                    : Icon(
                                        Icons.done,
                                        color: AppColors.green,
                                      )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Enter your password below",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.done,
                            controller: _passwordcontroller,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock_open,
                                  color: AppColors.green,
                                ),
                                suffixIcon: _obscureText
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = false;
                                          });
                                        },
                                        child: Icon(
                                          /*Icons.remove_red_eye,*/
                                          Icons.visibility_off,
                                          color: Colors.grey[700],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = true;
                                          });
                                        },
                                        child: Icon(
                                          /*Icons.remove_red_eye,*/
                                          Icons.visibility,
                                          color: Colors.grey[700],
                                        ),
                                      )),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              Color(0xff00C8E8) // Your color
                                          ),
                                      child: Checkbox(
                                          activeColor: AppColors.blue,
                                          value: true,
                                          onChanged: _handleRemeberme()),
                                    )),
                                const SizedBox(width: 10.0),
                                Text("Remember Me",
                                    style: GoogleFonts.openSans().copyWith(
                                        color: Color(0xff646464),
                                        fontSize: 14,
                                        fontFamily: 'Rubic')),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Forgot(),
                                          inheritTheme: true,
                                          ctx: context),
                                    );
                                  },
                                  child: Text("Forgot password?",
                                      style: GoogleFonts.openSans().copyWith(
                                          color: AppColors.pink,
                                          fontSize: 14,
                                          fontFamily: 'Rubic',
                                          decoration:
                                              TextDecoration.underline)),
                                )
                              ]),
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
                                  'Login',
                                  style: GoogleFonts.openSans().copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                iconData: Icons.login,
                                onPressed: () {
                                  if (_emailcontroller.text.isNotEmpty &&
                                      _passwordcontroller.text.isNotEmpty) {
                                    _loginUser(_emailcontroller.text,
                                        _passwordcontroller.text);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
