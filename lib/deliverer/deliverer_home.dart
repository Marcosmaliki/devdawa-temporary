import 'package:devdawa/auth/login.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/deliverer_menu_views/completed.dart';
import 'package:devdawa/views/deliverer_menu_views/deliverer_menu_home.dart';
import 'package:devdawa/views/deliverer_menu_views/deliverer_profile.dart';
import 'package:devdawa/views/order_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DelivererHome extends StatefulWidget {
  final Map user;
  final String token;

  DelivererHome({required this.user, required this.token});
  @override
  _DelivererHomeState createState() => _DelivererHomeState();
}

class _DelivererHomeState extends State<DelivererHome> {
  var base_client = BaseClient();

  bool _fetching_orders = true;
  List orders = [];

  bool _marking = false;

  bool _canceling = false;

  int _selectedIndex = 0;

  List menu_screens = [
    DelivererMenuHome(),
    CompletedOrders(),
    DelivererProfile()
  ];

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
    //_fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Deliverer Home"),
        actions: [
          PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("logged_in", false).then((value) {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Login(),
                          inheritTheme: true,
                          ctx: context),
                    );
                  });
                }
              },
              itemBuilder: (context) => [
                    /*PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                              child: Icon(
                                Icons.send,
                                color: Colors.black,
                              ),
                            ),
                            Text('Submit prescription')
                          ],
                        )),*/
                    PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                              child: Icon(
                                Icons.exit_to_app,
                                color: Colors.black,
                              ),
                            ),
                            Text('Logout')
                          ],
                        )),
                  ]),
        ],
      ),
      body: menu_screens[_selectedIndex],
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey.shade400,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.green,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: 'Home',
          backgroundColor: AppColors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          label: 'Completed',
          backgroundColor: AppColors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
          backgroundColor: AppColors.green,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.white,
      onTap: _onItemTapped,
    );
  }

  _onItemTapped(item) {
    setState(() {
      _selectedIndex = item;
    });
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
