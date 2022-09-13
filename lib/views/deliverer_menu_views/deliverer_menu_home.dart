import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/order_items.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/base_client.dart';

class DelivererMenuHome extends StatefulWidget {
  @override
  _DelivererMenuHomeState createState() => _DelivererMenuHomeState();
}

class _DelivererMenuHomeState extends State<DelivererMenuHome> {
  var base_client = BaseClient();

  bool _fetching_orders = true;
  List orders = [];

  bool _marking = false;

  bool _canceling = false;

  _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url +
            "/deliverer/orders?id=${prefs.getString("client_id")}",
        prefs.getString("token"));

    print(request_result);

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_orders = false;
          orders = request_result["data"]["data"]["data"];
        });

        print(orders);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _fetching_orders
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : orders.length < 1
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text("No Assignments"),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: AppColors.shade,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Tracking no.: "),
                                  Text(
                                    orders[index]["trackingNumber"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.green),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Customer phone.: "),
                                  Text(
                                    orders[index]["delivery_order"]
                                            ["order_client"]["client_user"]
                                        ["phone"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.green),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Customer email.: "),
                                  Text(
                                    orders[index]["delivery_order"]
                                            ["order_client"]["client_user"]
                                        ["email"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.green),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Customer: "),
                                  Text(
                                    orders[index]["delivery_order"]
                                                ["order_client"]["client_user"]
                                            ["surname"] +
                                        " " +
                                        orders[index]["delivery_order"]
                                                ["order_client"]["client_user"]
                                            ["othernames"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.green),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: ViewOrdered(
                                              order_id: orders[index]["id"],
                                              items: [],
                                            ),
                                            inheritTheme: true,
                                            ctx: context),
                                      );

                                      /*Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: ViewOrdered(
                                              order_id: "ur8r98r9r",
                                              items: [],
                                            ),
                                            inheritTheme: true,
                                            ctx: context),
                                      );*/
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shopping_basket_rounded),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          //Text("View Items")
                                        ],
                                      ),
                                    ),
                                  ),
                                  orders[index]["delivery_order"]["cartStatus"]
                                              .toString() !=
                                          "0"
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _marking = true;
                                              _markDelivered(
                                                  orders[index]["orderId"]);
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: AppColors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: _marking
                                                ? Center(
                                                    child: Text("Processing.."),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: AppColors.green,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "Mark as delivered",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .green),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _deleteDelivery(orders[index]["delivererId"],
                                      orders[index]["orderId"]);
                                },
                                child: Container(
                                  height: 45,
                                  margin: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel, color: AppColors.red),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        _canceling
                                            ? "Canceling..."
                                            : "Cancel delivery",
                                        style: TextStyle(
                                            color: AppColors.red,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  _deleteDelivery(String deliverer_d, String order_id) async {
    setState(() {
      _canceling = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map data = {"deliverer": deliverer_d, "order": order_id};

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/deliverer/assigned/cancel",
        data,
        prefs.getString("token").toString());

    print(request_result);

    setState(() {
      _canceling = false;
    });

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      setState(() {
        orders.clear();
        _fetching_orders = true;
        _fetchOrders();
      });
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }
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

  _markDelivered(String order_id) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {"deliverer": prefs.getString("client_id"), "order": order_id};

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/delivery/deliver",
        data,
        prefs.getString("token").toString());

    setState(() {
      _marking = false;
    });

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      setState(() {
        _marking = false;
        orders.clear();
        _fetching_orders = true;
        _fetchOrders();
      });
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    print(request_result);
  }
}
