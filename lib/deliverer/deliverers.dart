import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/base_client.dart';

class Deliverers extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;
  final String order_id;

  Deliverers(
      {required this.user,
      required this.token,
      required this.business_id,
      required this.order_id});

  @override
  _DeliverersState createState() => _DeliverersState();
}

class _DeliverersState extends State<Deliverers> {
  var base_client = BaseClient();

  bool _fetching_ds = true;
  List deliverers = [];

  bool _assigning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchDeliverers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Delivery Agents"),
      ),
      body: _fetching_ds
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: deliverers.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.shade),
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Name: "),
                                Text(
                                  deliverers[index]["deliverer_user"]["surname"]
                                          .toString() +
                                      " " +
                                      deliverers[index]["deliverer_user"]
                                              ["othernames"]
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text("Phone: "),
                                Text(
                                  deliverers[index]["deliverer_user"]["phone"]
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            deliverers[index]["availability"].toString() == "0"
                                ? GestureDetector(
                                    onTap: () {
                                      _assignOrder(deliverers[index]["id"]);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.green[200],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: !_assigning
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add_task),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text("Assign")
                                              ],
                                            )
                                          : Center(child: Text("Assigning...")),
                                    ),
                                  )
                                : Text(
                                    "Not Available",
                                    style: TextStyle(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.w600),
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
                },
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

  _assignOrder(String d_id) async {
    setState(() {
      _assigning = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map data = {"deliverer": d_id, "order": widget.order_id};
    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/deliverer/assign/order",
        data,
        prefs.getString("token").toString());

    print(request_result);

    if (request_result["data"]["success"]) {
      _showSnackBar("Order assigned", Colors.green, Icons.done, Colors.white,
          Colors.white);
      setState(() {
        deliverers.clear();
        _fetching_ds = true;
        _fetchDeliverers();
      });
    }

    setState(() {
      _assigning = false;
    });
  }

  _fetchDeliverers() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/deliverer/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_ds = false;
          deliverers = request_result["data"]["data"]["data"];
        });

        //print(orders);
      }
    }
  }
}
