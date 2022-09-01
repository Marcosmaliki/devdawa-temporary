import 'package:devdawa/auth/login.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  bool _obscureConfirm = true;

  var base_client = BaseClient();

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _surnamecontroller = TextEditingController();
  final TextEditingController _othercontroller = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final IconButtonController _loadingBtnController = IconButtonController();

  bool _email_valid = false;

  _handleRemeberme() {}

  _isValidEmail(email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
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
                    height: 250,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
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
                        left: 10, right: 10, top: 15, bottom: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Account",
                            /*style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),*/
                            style: GoogleFonts.openSans().copyWith(
                                fontWeight: FontWeight.w600,
                                //color: Colors.white,
                                fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Enter your email address below",
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
                            height: 10,
                          ),
                          Text(
                            "Type your username",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Enter phone number",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          IntlPhoneField(
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              /*border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),*/
                            ),
                            initialCountryCode: 'KE',
                            onChanged: (phone) {
                              _phoneController.text = phone.completeNumber
                                  .toString()
                                  .substring(4,
                                      phone.completeNumber.toString().length);
                              /*print(phone.completeNumber);*/
                            },
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Text(
                            "Enter other names",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: _othercontroller,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Other names',
                              prefixIcon: Icon(
                                Icons.add,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                          Text(
                            "Enter surname",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: _surnamecontroller,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Surname',
                              prefixIcon: Icon(
                                Icons.person,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Text(
                            "Enter your password below",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
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
                            height: 10,
                          ),
                          Text(
                            "Retype password below",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey[400], fontSize: 13),
                          ),
                          TextField(
                            textInputAction: TextInputAction.done,
                            controller: _confirmController,
                            obscureText: _obscureConfirm,
                            decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                prefixIcon: Icon(
                                  Icons.lock_open,
                                  color: AppColors.green,
                                ),
                                suffixIcon: _obscureConfirm
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureConfirm = false;
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
                                            _obscureConfirm = true;
                                          });
                                        },
                                        child: Icon(
                                          /*Icons.remove_red_eye,*/
                                          Icons.visibility,
                                          color: Colors.grey[700],
                                        ),
                                      )),
                          ),
                          SizedBox(
                            height: 20,
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
                                  'Sign Up',
                                  style: GoogleFonts.openSans().copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                iconData: Icons.app_registration,
                                onPressed: () {
                                  //print(_phoneController.text);
                                  if (_emailcontroller.text.isNotEmpty &&
                                      _usernameController.text.isNotEmpty &&
                                      _passwordcontroller.text.isNotEmpty &&
                                      _confirmController.text.isNotEmpty &&
                                      _surnamecontroller.text.isNotEmpty &&
                                      _othercontroller.text.isNotEmpty) {
                                    if (_phoneController.text.length > 9) {
                                      if (_passwordcontroller.text ==
                                          _confirmController.text) {
                                        _signUpUser(
                                            _emailcontroller.text,
                                            _usernameController.text,
                                            _phoneController.text,
                                            _passwordcontroller.text,
                                            _confirmController.text,
                                            _surnamecontroller.text,
                                            _othercontroller.text);
                                      } else {
                                        _loadingBtnController.reset();
                                        _showSnackBar(
                                            "Passwords don't match",
                                            Colors.amber,
                                            Icons.info,
                                            Colors.black,
                                            Colors.black);
                                      }
                                    } else {
                                      _loadingBtnController.reset();
                                      _showSnackBar(
                                          "Wrong phone number format",
                                          Colors.red,
                                          Icons.error,
                                          Colors.white,
                                          Colors.white);
                                    }
                                  } else {
                                    _loadingBtnController.reset();
                                    _showSnackBar(
                                        "All fields are required",
                                        Colors.red,
                                        Icons.error,
                                        Colors.white,
                                        Colors.white);
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

  _goLogin() {
    _loadingBtnController.reset();
    _showSnackBar("Account created", Colors.green, Icons.check_circle_outline,
        Colors.white, Colors.white);

    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: Login(),
          inheritTheme: true,
          ctx: context),
    );
  }

  _signUpUser(
      email, username, phone, password, confirm, surname, othername) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "password": password,
      "password_confirmation": confirm,
      "username": username,
      "surname": surname,
      "othernames": othername,
      /*"idNo": "657478474",
      "kraPin": "AI878N485748N74",*/
      "email": email,
      "phone": "254" + phone.substring(1, phone.length),
      "role": "client",
      "locationId": "ff9db561-da95-11ec-9a5c-18dbf20f0b96",
      "locationDetails": "No details"
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/user/auth/register", data);

    if (request_result["response"] == 200) {
      _loadingBtnController.reset();
      if (request_result["data"]["success"]) {
        _loadingBtnController.reset();
        _goLogin();
      } else {
        _loadingBtnController.reset();
        _showSnackBar(request_result["data"]["message"], Colors.red,
            Icons.error, Colors.white, Colors.white);
      }
    } else {
      _showSnackBar("Something went wrong", Colors.amber, Icons.info,
          Colors.black, Colors.black);
      _loadingBtnController.error();
      Future.delayed(const Duration(seconds: 1), () {
        _loadingBtnController.reset();
      });
    }

    //print(request_result["data"]);

    /*Future.delayed(const Duration(seconds: 1), () {
      _loadingBtnController.error();
      Future.delayed(const Duration(seconds: 1), () {
        _loadingBtnController.reset();
      });
    });*/
  }
}
