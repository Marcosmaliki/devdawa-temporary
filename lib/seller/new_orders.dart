import 'package:devdawa/deliverer/deliverers.dart';
import 'package:devdawa/seller/ordered_items.dart';
import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrders extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;
  final List orderslist;

  NewOrders(
      {required this.user,
      required this.token,
      required this.business_id,
      required this.orderslist});

  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  bool _canceling = false;

  var base_client = BaseClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("New Orders"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: widget.orderslist.length,
          itemBuilder: (_, index) {
            return Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.shade),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Name: "),
                        Text(
                          widget.orderslist[index]["order_client"]
                                      ["client_user"]["othernames"]
                                  .toString() +
                              " " +
                              widget.orderslist[index]["order_client"]
                                      ["client_user"]["surname"]
                                  .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
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
                          widget.orderslist[index]["order_client"]
                                  ["client_user"]["phone"]
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Email: "),
                        Text(
                          widget.orderslist[index]["order_client"]
                                  ["client_user"]["email"]
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Total amount: "),
                        Text(
                          widget.orderslist[index]["totalAmount"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Discount: "),
                        Text(
                          widget.orderslist[index]["discount"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
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
                                  child: OrderedItems(
                                    user: widget.user,
                                    token: widget.token,
                                    business_id: widget.business_id,
                                    itemslist: widget.orderslist[index]
                                        ["order_items"],
                                  ),
                                  inheritTheme: true,
                                  ctx: context),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.more),
                                SizedBox(
                                  width: 4,
                                ),
                                Text("See Items")
                              ],
                            ),
                          ),
                        ),
                        widget.orderslist[index]["order_delivery"] != null
                            ? Container(
                                height: 40,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.directions_bike,
                                      color: AppColors.pink[300],
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text("Delivery underway")
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  //print(widget.orderslist[index]["id"]);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Deliverers(
                                          user: widget.user,
                                          token: widget.token,
                                          business_id: widget.business_id,
                                          order_id: widget.orderslist[index]
                                                  ["id"]
                                              .toString(),
                                        ),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.pink[200],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("Assign Delivery")],
                                  ),
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _canceling = true;
                        });
                        _counselOrder(widget.orderslist[index]["id"]);
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: AppColors.grey),
                        child: _canceling
                            ? Center(
                                child: Text(
                                  "Cancelling...",
                                  style: TextStyle(color: AppColors.pink),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.clear),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Cancel Order")
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              ),
            );

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: OrderedItems(
                        user: widget.user,
                        token: widget.token,
                        business_id: widget.business_id,
                        itemslist: widget.orderslist[index]["order_items"],
                      ),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: _orderItem(
                widget.orderslist[index]["order_client"]["client_user"]
                    ["surname"],
                widget.orderslist[index]["order_client"]["client_user"]
                    ["phone"],
                widget.orderslist[index]["order_client"]["client_user"]
                    ["othernames"],
                widget.orderslist[index]["order_client"]["client_user"]
                    ["email"],
                widget.orderslist[index]["totalAmount"].toString(),
                widget.orderslist[index]["discount"].toString(),
              ),
            );
          },
        ),
      ),
    );
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
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: SellerHome(
                user: widget.user,
                token: prefs.getString("token").toString(),
              ),
              inheritTheme: true,
              ctx: context),
        );
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

  Widget _orderItem(
      String client_surname,
      String client_phone,
      String client_othername,
      String client_email,
      String total_amount,
      String discount) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.shade),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Name: "),
                Text(
                  client_othername.toString() + " " + client_surname.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                  client_phone.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text("Email: "),
                Text(
                  client_email.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text("Total amount: "),
                Text(
                  total_amount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more),
                      SizedBox(
                        width: 4,
                      ),
                      Text("See Items")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    /*Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Deliverers(
                            user: widget.user,
                            token: widget.token,
                            business_id: widget.business_id,
                            order_id: ,
                          ),
                          inheritTheme: true,
                          ctx: context),
                    );*/
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.pink[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Assign Delivery")],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
