import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/condtion_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/base_client.dart';

class AllConditions extends StatefulWidget {
  @override
  _AllConditionsState createState() => _AllConditionsState();
}

class _AllConditionsState extends State<AllConditions> {
  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

  bool _fetching_conditions = true;

  List conditions = [];

  _fetchConditions() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/condition/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_conditions = false;
          conditions = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "Conditions",
          style: GoogleFonts.openSans().copyWith(),
        ),
      ),
      body: _fetching_conditions
          ? Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : conditions.length > 0
              ? Container(
                  margin: EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: conditions.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ConditionsProducts(
                                  condition:
                                      conditions[index]["condition"].toString(),
                                  condition_id:
                                      conditions[index]["id"].toString(),
                                ),
                                inheritTheme: true,
                                ctx: context),
                          );
                        },
                        child: _conditionItem(
                            conditions[index]["condition"],
                            conditions[index]["id"],
                            conditions[index]["condition"]),
                      );
                    },
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text("No conditions"),
                  ),
                ),
    );
  }

  Widget _conditionItem(String name, String uuid, String category) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: AppColors.shade,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text(
                name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text(
                "Categoty: " + category.toString(),
                style: TextStyle(color: AppColors.green),
              ),
            ],
          )
        ],
      ),
    );
  }
}
