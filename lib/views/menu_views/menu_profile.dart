import 'package:devdawa/auth/change_password.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuProfile extends StatefulWidget {
  @override
  _MenuProfileState createState() => _MenuProfileState();
}

class _MenuProfileState extends State<MenuProfile> {
  double _editHeight = 0;
  double _detailsHeight = 325.0;
  bool _fetching = true;

  var base_client = BaseClient();

  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchDetails();
  }

  _fetchDetails() async {
    final prefs = await SharedPreferences.getInstance();

    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/user/${prefs.getString("user_uid")}/get",
        prefs.getString("token"));

    setState(() {
      _fetching = false;
      data.add(request_result["data"]["data"]);
    });

    //print("DEtails are " + request_result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: scaffoldKey,
      body: _fetching
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              //duration: const Duration(milliseconds: 500),
              height: 325,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        /*Icon(CartIcons.user_1_),
              SizedBox(width: 10,),*/
                        Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ChangePassword(),
                                  inheritTheme: true,
                                  ctx: context),
                            );
                          },
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.ac_unit),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Name: ${data[0]["surname"]}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Other Names: ${data[0]["othernames"]}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.storage),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ID No.: ${data[0]["idNo"]}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Email: ${data[0]["email"]}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Phone: ${data[0]["phone"]}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.green,
                      ),
                      child: Text("Edit"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: EditProfile(
                                name: data[0]["surname"],
                                other: data[0]["othernames"],
                                id_no: data[0]["idNo"].toString(),
                                email: data[0]["email"],
                                phone: data[0]["phone"],
                              ),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
