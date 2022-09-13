import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedOrders extends StatefulWidget {
  @override
  _CompletedOrdersState createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  var base_client = BaseClient();

  bool _fetching_orders = true;
  List orders = [];

  bool _marking = false;

  bool _canceling = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrders();
  }

  _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url +
            "/deliverer/orders/completed?id=${prefs.getString("client_id")}",
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
                    child: Text("No completed delieveries"),
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
                              /*SizedBox(
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
                                    order_id: "ur8r98r9r",
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
                      ],
                    ),*/
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
