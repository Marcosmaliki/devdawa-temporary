import 'package:devdawa/auth/login.dart';
import 'package:devdawa/seller/add_bisiness.dart';
import 'package:devdawa/seller/products.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerHome extends StatefulWidget {
  final Map user;
  final String token;

  SellerHome({required this.user, required this.token});

  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  bool _fetching_business = true;

  var base_client = BaseClient();

  List businesses = [];

  DateTime? currentBackPressTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBusiness();
  }

  _showSnackBar(message, color, icon) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(message)
        ],
      ),
      backgroundColor: color,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _fetchBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url +
            "/seller-business/get/${prefs.getString("client_id")}",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_business = false;
          businesses = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    //primary: Colors.grey[300],
    primary: Colors.deepOrange,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 5)) {
          currentBackPressTime = now;
          //Fluttertoast.showToast(msg: exit_warning);
          _showSnackBar("Tap again to close", Colors.grey, Icons.close);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text("Businesses"),
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
        body: _fetching_business
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : businesses.length > 0
                ? Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: businesses.length,
                          itemBuilder: (_, index) {
                            return _businessItem(
                              businesses[index]["businessName"],
                              businesses[index]["regNo"],
                              businesses[index]["type"],
                              businesses[index]["business_rating"] == null
                                  ? "0"
                                  : businesses[index]["business_rating"]
                                      .toString(),
                              businesses[index]["id"],
                            );
                          },
                        )),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("No businesses"),
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _addBusiness();
          },
        ),
      ),
    );
  }

  Widget _businessItem(name, reg, btype, rating, business_id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: BusinessProducts(
                user: widget.user,
                token: widget.token,
                business_id: business_id,
              ),
              inheritTheme: true,
              ctx: context),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 135,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 7),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Name: "),
                    Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Reg no.: "),
                    Text(
                      reg,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text("Business type: "),
                    Text(
                      btype,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "Rating: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(rating.toString()),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: BusinessProducts(
                                user: widget.user,
                                token: widget.token,
                                business_id: business_id,
                              ),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text("View"),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AddBusiness(
              user: widget.user,
              token: widget.token,
              seller_id: prefs.getString("client_id").toString()),
          inheritTheme: true,
          ctx: context),
    );
  }
}
