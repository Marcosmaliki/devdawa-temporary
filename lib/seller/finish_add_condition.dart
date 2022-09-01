import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddConditionProdFinish extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;
  final String product_id;

  AddConditionProdFinish(
      {required this.user,
      required this.token,
      required this.business_id,
      required this.product_id});
  @override
  _AddConditionProdFinishState createState() => _AddConditionProdFinishState();
}

class _AddConditionProdFinishState extends State<AddConditionProdFinish> {
  List<String> conditions_list = [];

  List conditions = [];

  String? condition;

  String? conditionId;

  bool _fetch_condition = true;

  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

  _fetchConditions() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/condition/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_condition = false;
          conditions = request_result["data"]["data"]["data"];
        });

        for (var category in conditions) {
          setState(() {
            conditions_list.add(category["condition"]);
          });
        }
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
        title: Text("Add Condition Product"),
      ),
      body: _fetch_condition
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : conditions.length > 0
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropDown(
                        items: conditions_list,
                        hint: Text("Choose condtion"),
                        icon: Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            condition = val.toString();
                          });

                          for (var con in conditions) {
                            if (con["condition"] == val.toString()) {
                              setState(() {
                                conditionId = con["id"];
                              });
                            }
                          }
                        },
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
                              'Add as condition product',
                              style: GoogleFonts.openSans().copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            iconData: Icons.login,
                            onPressed: () {
                              if (conditionId != null) {
                                _createProduct();
                              } else {
                                _loadingBtnController.reset();
                                _showSnackBar("Pick a condition", Colors.amber,
                                    Icons.error, Colors.black, Colors.black);
                              }
                            },
                            successIcon: Icons.check_circle_outline,
                            controller: _loadingBtnController,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text("No conditions"),
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

  _createProduct() async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "productId": widget.product_id,
      "conditionId": conditionId,
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/condition/product/add", data);

    _loadingBtnController.reset();

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      Future.delayed(const Duration(seconds: 1), () {
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
      });
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    //print(request_result);
  }
}
