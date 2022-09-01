import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String other;
  final String id_no;
  final String email;
  final String phone;

  EditProfile(
      {required this.name,
      required this.other,
      required this.id_no,
      required this.email,
      required this.phone});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final IconButtonController _loadingBtnController = IconButtonController();

  var base_client = BaseClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _nameController.text = widget.name;
      _otherController.text = widget.other;
      _idController.text = widget.id_no;
      _emailController.text = widget.email;
      _phoneController.text = widget.phone;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Edit profile"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Surname",
              style: GoogleFonts.openSans()
                  .copyWith(color: Colors.grey[400], fontSize: 13),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _nameController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Surname',
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.green,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Other names",
              style: GoogleFonts.openSans()
                  .copyWith(color: Colors.grey[400], fontSize: 13),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _otherController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Other name',
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.green,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "ID number",
              style: GoogleFonts.openSans()
                  .copyWith(color: Colors.grey[400], fontSize: 13),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _idController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'ID number',
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.green,
                ),
              ),
            ),
            /*SizedBox(
              height: 10,
            ),
            Text(
              "Email",
              style: GoogleFonts.openSans()
                  .copyWith(color: Colors.grey[400], fontSize: 13),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _emailController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Email Address',
                prefixIcon: Icon(
                  Icons.email,
                  color: AppColors.green,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Phone",
              style: GoogleFonts.openSans()
                  .copyWith(color: Colors.grey[400], fontSize: 13),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              controller: _phoneController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Phone',
                prefixIcon: Icon(
                  Icons.phone,
                  color: AppColors.green,
                ),
              ),
            ),*/
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
                    'Submit',
                    style: GoogleFonts.openSans().copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  iconData: Icons.app_registration,
                  onPressed: () {
                    //print(_phoneController.text);
                    if (_nameController.text.isNotEmpty &&
                        _otherController.text.isNotEmpty &&
                        _idController.text.isNotEmpty) {
                      _changeProfile();
                    } else {
                      _loadingBtnController.reset();
                      _showSnackBar("All fields are required", Colors.red,
                          Icons.error, Colors.white, Colors.white);
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
    );
  }

  _changeProfile() async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "surname": _nameController.text,
      "othernames": _otherController.text,
      "idNo": _idController.text,
    };

    print(data);

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/user/profile/update", data);

    print(request_result);

    _loadingBtnController.reset();

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      /*Future.delayed(const Duration(seconds: 1), () {
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
      });*/
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    //print(request_result);
  }
}
