import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/checkout.dart';
import 'package:devdawa/views/home.dart';
import 'package:devdawa/views/make_payment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainCart extends StatefulWidget {
  final Map user;

  MainCart({required this.user});

  @override
  _MainCartState createState() => _MainCartState();
}

class _MainCartState extends State<MainCart> {
  int _quantity = 1;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var base_client = BaseClient();

  List<dynamic> cart = [];

  bool _fetching_cart = true;

  bool counting = true;

  int _delivery_charges = 0;

  int total_charge = 0;
  int sub_total = 0;

  bool calculating = true;

  bool _submitting_change = false;

  bool _ordering = false;

  TextEditingController _countController = TextEditingController();

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCart();
  }

  _getCart() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url +
            "/cart/all?clientId=${prefs.getString("client_id")}",
        prefs.getString("token"));

    for (var item in request_result["data"]["data"]["data"]) {
      setState(() {
        /*_delivery_charges += sub_total += (int.parse(
                item["cart_product"]["product_pricing"]["price"].toString()) *
            int.parse(item["number"].toString()));*/
        total_charge += (int.parse(
                item["cart_product"]["product_pricing"]["price"].toString()) *
            int.parse(item["number"].toString()));
        /*total_charge += _delivery_charges;

        sub_total += (int.parse(
            item["cart_product"]["product_pricing"]["price"].toString()));
        total_charge += (int.parse(
            item["cart_product"]["product_pricing"]["price"].toString()));*/
        total_charge += _delivery_charges;
      });
    }

    setState(() {
      cart = request_result["data"]["data"]["data"];
      _fetching_cart = false;
    });

    //print(request_result["data"]["data"]["data"].length);
  }

  Widget _cartItem(id, name, quantity, amount, image) {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.scaleDown,
                  )),
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: $name",
              style:
                  GoogleFonts.openSans().copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quantity: $quantity",
                  //"Quantity: 2",
                  style: GoogleFonts.openSans()
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 100,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _countController.text = quantity.toString();
                    });
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 120,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      name.length <= 15
                                          ? "Name: $name"
                                          : "Name: ${name.substring(0, 15)}...",
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                    ),

                                    /*FlatButton(
                                      color: AppColors.red,
                                      child: Text("Remove"),
                                      onPressed: () {
                                        _removeItem(id.toString());
                                      },
                                    ),*/

                                    GestureDetector(
                                      onTap: () {
                                        _removeItem(id.toString());
                                      },
                                      child: Container(
                                        height: 28,
                                        width: 70,
                                        color: AppColors.red,
                                        child: Center(
                                          child: Text("Remove"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 150,
                                      child: TextField(
                                        cursorHeight: 20,
                                        autofocus: false,
                                        controller: _countController,
                                        decoration: InputDecoration(
                                          /*labelText: 'Enter item 1',
                                          hintText: "Enter item 1",*/
                                          /*prefixIcon: Icon(Icons.star),
                                          suffixIcon:
                                              Icon(Icons.keyboard_arrow_down),*/
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            gapPadding: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: AppColors.green,
                                                width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    /*FlatButton(
                                      color: AppColors.green_shade,
                                      child: !_submitting_change
                                          ? Text("Submit Change")
                                          : Text("Processing..."),
                                      onPressed: () {
                                        if (_countController.text.isNotEmpty ||
                                            !_submitting_change) {
                                          _editItem(id.toString(),
                                              _countController.text);
                                        } else {
                                          Navigator.pop(context);
                                          _showSnackBar(
                                              "Mandatory field missing",
                                              Colors.red,
                                              Icons.error,
                                              Colors.white,
                                              Colors.white);
                                        }
                                      },
                                    ),*/

                                    GestureDetector(
                                      onTap: () {
                                        if (_countController.text.isNotEmpty ||
                                            !_submitting_change) {
                                          _editItem(id.toString(),
                                              _countController.text);
                                        } else {
                                          Navigator.pop(context);
                                          _showSnackBar(
                                              "Mandatory field missing",
                                              Colors.red,
                                              Icons.error,
                                              Colors.white,
                                              Colors.white);
                                        }
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 150,
                                        color: AppColors.green_shade,
                                        child: Center(
                                          child: !_submitting_change
                                              ? Text("Submit Change")
                                              : Text("Processing..."),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: AppColors.green_shade,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Edit",
                        style: TextStyle(color: AppColors.green),
                      )
                    ],
                  ),
                )
                /*const SizedBox(
                  width: 70,
                ),
                Container(
                  height: 30,
                  width: 105,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: <Widget>[
                    InkWell(
                      child: const Icon(
                        Icons.remove,
                        size: 15,
                      ),
                      onTap: _decrement,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(_quantity.toString(),
                            style: const TextStyle(fontSize: 20))),
                    InkWell(
                      child: const Icon(
                        Icons.add,
                        size: 15,
                      ),
                      onTap: _increment,
                    ),
                  ]),
                )*/
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Amount: Ksh ${amount.toString()}",
              style:
                  GoogleFonts.openSans().copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
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

  _removeItem(product_id) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {"cartId": product_id};

    Navigator.pop(context);

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/cart/remove",
        data,
        prefs.getString("token").toString());

    _showSnackBar(
        "Item deleted", Colors.green, Icons.done, Colors.white, Colors.white);

    setState(() {
      sub_total = 0;
      total_charge = 0;
      _fetching_cart = true;
      cart.clear();
      _getCart();
    });
  }

  _editItem(product_id, number) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {"cartId": product_id, "number": number};

    Navigator.pop(context);

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/cart/edit",
        data,
        prefs.getString("token").toString());

    _showSnackBar(
        "Item edited", Colors.green, Icons.done, Colors.white, Colors.white);

    setState(() {
      sub_total = 0;
      total_charge = 0;
      _fetching_cart = true;
      cart.clear();
      _getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            "Basket",
            style: GoogleFonts.openSans().copyWith(),
          ),
        ),
        body: _fetching_cart
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : cart.length > 0
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Your Basket",
                            style: GoogleFonts.openSans().copyWith(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 350,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: AppColors.white),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: cart.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: _cartItem(
                                        cart[index]["id"],
                                        cart[index]["cart_product"]["name"],
                                        cart[index]["number"].toString(),
                                        (int.parse(cart[index]["cart_product"]
                                                            ["product_pricing"]
                                                        ["price"]
                                                    .toString()) *
                                                int.parse(cart[index]["number"]
                                                    .toString()))
                                            .toString(),
                                        cart[index]["cart_product"]
                                                ["product_image"][0]["image"]
                                            .toString()));
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.openSans().copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Ksh ${total_charge.toString()}.00",
                                style: GoogleFonts.openSans().copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          /*SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery charges",
                            style: GoogleFonts.openSans().copyWith(
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Ksh ${_delivery_charges.toString()}.00",
                            style: GoogleFonts.openSans().copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),*/
                          SizedBox(
                            height: 10,
                          ),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sub Total",
                                style: GoogleFonts.openSans().copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Ksh ${sub_total.toString()}.00",
                                style: GoogleFonts.openSans().copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),*/
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _placeTheOrder();
                                /*Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CheckOutScreen(),
                                  inheritTheme: true,
                                  ctx: context),
                            );*/
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 50,
                                  width: 230,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.green,
                                  ),
                                  child: Center(
                                    child: _ordering
                                        ? Text(
                                            "Processing...",
                                            style: TextStyle(
                                                color: AppColors.white),
                                          )
                                        : Text(
                                            "Make Payment",
                                            //"Check Out",
                                            style: GoogleFonts.openSans()
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("Cart is empty"),
                    ),
                  ));
  }

  _placeTheOrder() async {
    setState(() {
      _ordering = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map data = {"clientId": prefs.getString("client_id")};
    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/order/create",
        data,
        prefs.getString("token").toString());

    //print(request_result);

//    print(request_result["data"]["data"][0]["id"]);
    //print("Data is " + request_result["data"]["data"].toString());

    //print(request_result.toString());

    print(request_result["data"]["data"][0]);

    setState(() {
      _ordering = false;
    });

    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: MakePayment(
            user: widget.user,
            order_id: request_result["data"]["data"][0]["id"],
            total: total_charge.toString(),
            order: request_result["data"]["data"][0],
          ),
          inheritTheme: true,
          ctx: context),
    );

    /*_showSnackBar(
        "Order Placed", Colors.green, Icons.done, Colors.white, Colors.white);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: HomeScreen(
              user: widget.user,
              token: prefs.getString("token").toString(),
            ),
            inheritTheme: true,
            ctx: context),
      );
    });*/
  }
}
