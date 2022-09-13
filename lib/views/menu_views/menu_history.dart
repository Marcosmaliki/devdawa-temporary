import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/order_items.dart';
import 'package:devdawa/views/rate_delivery.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuHistory extends StatefulWidget {
  @override
  _MenuHistoryState createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {
  List _orders = [
    /*{
      "order_id": "fhduhdhdhihdhihdih",
      "tracking": "FNF8R978RBF7BDB",
      "cost": "500.00",
      "inventory": "50",
      "quantity": "10"
    },
    {
      "order_id": "fhduhdhdhihdhihdih",
      "tracking": "FNF8R978RBF7BDB",
      "cost": "500.00",
      "inventory": "50",
      "quantity": "10"
    },
    {
      "order_id": "fhduhdhdhihdhihdih",
      "tracking": "FNF8R978RBF7BDB",
      "cost": "500.00",
      "inventory": "50",
      "quantity": "10"
    },
    {
      "order_id": "fhduhdhdhihdhihdih",
      "tracking": "FNF8R978RBF7BDB",
      "cost": "500.00",
      "inventory": "50",
      "quantity": "10"
    },*/
  ];
  bool _fetch_orders = true;
  String? token;
  bool _canceling = false;
  bool _marking = false;
  var base_client = BaseClient();

  @override
  void initState() {
    super.initState();

    _getOrders();
    _getToken();
  }

  _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  _getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url +
            "/order/client-orders/processed/${prefs.getString("client_id")}/get",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_orders = false;
          _orders = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _fetch_orders
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _orders.length > 0
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _orders.length,
                  itemBuilder: (_, index) {
                    //print(_orders[0]["cartStatus"]);
                    return _orderItem(
                        "jhdj",
                        _orders[index]["totalAmount"].toString(),
                        _orders[index]["order_items"].length.toString(),
                        _orders[index]["order_items"].length.toString(),
                        _orders[index]["id"].length.toString(),
                        _orders[index]["cartStatus"].toString(),
                        _orders[index]["order_delivery"]["delivererId"]
                            .toString()
                        /*_orders[index]["tracking"],
                        _orders[index]["cost"],
                        _orders[index]["inventory"].toString(),
                        _orders[index]["quantity"].toString(),
                        _orders[index]["order_id"].toString()*/
                        );
                  },
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text("No history"),
                ),
              );
  }

  Widget _orderItem(String name, String inventory, String count,
      String quantity, String order_id, String status, String deliverer_id) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: 144,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.shade),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 5, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Row(
                  children: [
                    Text("Tracking Number: "),
                    Text(
                      name.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),*/
                /*Row(
                  children: [
                    Text("Inventory: "),
                    Text(
                      inventory.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),*/
                Row(
                  children: [
                    Text("Order count: "),
                    Text(
                      quantity.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text("Delivery status: "),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.green,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Delivered",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.green),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ViewOrdered(
                                order_id: order_id,
                                items: [],
                              ),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_basket_rounded),
                            SizedBox(
                              width: 4,
                            ),
                            Text("View Items")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                status == "3"
                    ? GestureDetector(
                        onTap: () {
                          _confirmRecieved(order_id, deliverer_id);
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.money, color: AppColors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                _marking
                                    ? "Confirming..."
                                    : "Confirm Order Recieved",
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _confirmRecieved(String order_id, String deliverer_id) async {
    setState(() {
      _marking = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map data = {"client": prefs.getString("client_id"), "order": order_id};

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/delivery/receive",
        data,
        prefs.getString("token").toString());

    print(request_result);

    setState(() {
      _marking = false;
    });

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: RateDelivery(
              token: token.toString(),
              deliverer_id: deliverer_id,
              order_id: order_id,
            ),
            inheritTheme: true,
            ctx: context),
      );

      setState(() {
        _marking = false;
        _orders.clear();
        _fetch_orders = true;
        _getOrders();
      });
    } else {
      _showSnackBar(
          request_result["data"]["message"].toString().substring(0, 10),
          Colors.red,
          Icons.error,
          Colors.white,
          Colors.white);
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
}
