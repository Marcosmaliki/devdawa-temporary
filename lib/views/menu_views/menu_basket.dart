import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/checkout.dart';
import 'package:devdawa/views/order_items.dart';
import 'package:devdawa/views/rate_delivery.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuBasket extends StatefulWidget {
  @override
  _MenuBasketState createState() => _MenuBasketState();
}

class _MenuBasketState extends State<MenuBasket> {
  bool _fetch_orders = true;
  String? token;
  bool _canceling = false;
  bool _marking = false;
  List _orders = [];
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
            "/order/client-orders/pending/${prefs.getString("client_id")}/get",
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _orders.length,
                  itemBuilder: (_, index) {
                    return _orderItem(
                        _orders[index]["discount"].toString(),
                        _orders[index]["totalAmount"].toString(),
                        _orders[index]["order_items"].length.toString(),
                        _orders[index]["order_items"].length.toString(),
                        _orders[index]["id"].toString(),
                        _orders[index]["cartStatus"].toString(),
                        _orders[index]["order_delivery"] == null
                            ? "none"
                            : _orders[index]["order_delivery"]["delivererId"]
                                .toString(),
                        _orders[index]["order_items"]);
                  },
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text("No orders"),
                ),
              );
  }

  Widget _orderItem(
      String discount,
      String inventory,
      String count,
      String quantity,
      String order_id,
      String status,
      String deliverer_id,
      List items) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        // height: status == "0" || status == "3" ? 214 : 152,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.shade),
        child: Padding(
          padding: EdgeInsets.only(top: 5, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Discount: "),
                  Text(
                    discount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Total Amount: "),
                  Text(
                    inventory.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Order count: "),
                  Text(
                    quantity.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              status == "2" || status == "3" || status == "4"
                  ? Row(
                      children: [
                        Text("Delivery status: "),
                        Row(
                          children: [
                            Icon(
                              Icons.bike_scooter,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Underway",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.green),
                            )
                          ],
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Text("Delivery status: "),
                        Row(
                          children: [
                            Icon(
                              Icons.downloading,
                              color: Colors.brown,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Waiting",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.brown),
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
                              items: items,
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
                  status == "0"
                      ? GestureDetector(
                          onTap: () {
                            _showSnackBar("Cancelling Order", Colors.amber,
                                Icons.info, Colors.black, Colors.black);
                            _counselOrder(order_id);
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              SizedBox(
                height: 5,
              ),
              status == "0"
                  ? GestureDetector(
                      onTap: () {
                        _payOrder(order_id);
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
                            Icon(Icons.money, color: AppColors.green),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Make payment now",
                              style: TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 5,
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
              SizedBox(
                height: 5,
              )
            ],
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
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }
  }

  _counselOrder(String order_id) async {
    setState(() {
      _canceling = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map data = {"orderId": order_id};
    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/order/cancel",
        data,
        prefs.getString("token").toString());

    print(request_result);

    setState(() {
      _canceling = false;
    });

    if (request_result["data"]["success"]) {
      _showSnackBar("Order Cancelled", Colors.green, Icons.done, Colors.white,
          Colors.white);

      setState(() {
        _orders.clear();
        _fetch_orders = true;
        _getOrders();
      });
    } else if (request_result["response"].toString() == "500") {
      _showSnackBar("Server error(500)", Colors.red, Icons.error_outline,
          Colors.white, Colors.white);
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error_outline,
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

  _payOrder(String order_id) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "orderId": order_id,
      "paymentMode": "6609d95d-df17-11ec-8e4b-18dbf20f0b96"
    };

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/order/pay",
        data,
        prefs.getString("token").toString());

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      setState(() {
        _orders.clear();
        _fetch_orders = true;
        _getOrders();
      });
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    print(request_result);
  }
}
