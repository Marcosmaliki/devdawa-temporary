import 'package:badges/badges.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDetail extends StatefulWidget {
  final String token;
  final Map data;
  final Map user;
  final List<dynamic> cart;
  final int cart_count;
  const CategoryDetail(
      {Key? key,
      required this.token,
      required this.data,
      required this.user,
      required this.cart_count,
      required this.cart})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  double defaultPadding = 30.0;
  double defaultBorderRadius = 10.0;

  int _quantity = 1;
  int _cart_items = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool counting = true;

  bool _adding_to_cart = false;

  var base_client = BaseClient();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cart_items = widget.cart_count;
    print(widget.data["image"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: HomeScreen(
                user: widget.user,
                token: widget.token,
              ),
              inheritTheme: true,
              ctx: context),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          /*leading: BackButton(
            color: Colors.black,
          ),*/
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.black,
              )),
          actions: [
            IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )))
          ],
        ),
        body: Column(
          children: [
            Image.network(
              widget.data["image"].toString(),
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),
            SizedBox(height: defaultPadding * 1.5),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    defaultPadding, 5, defaultPadding, defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(defaultBorderRadius * 3),
                    topRight: Radius.circular(defaultBorderRadius * 3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.data["name"].toString(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SizedBox(width: defaultPadding),
                        Icon(
                          Icons.storage,
                          size: 15,
                          color: AppColors.red,
                        ),
                        SizedBox(width: 3),
                        Text(
                          widget.data["stock"].toString(),
                          //"20 in store",
                          style: GoogleFonts.openSans().copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.green),
                        ),
                      ],
                    ),

                    //Counter section
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(children: <Widget>[
                                  InkWell(
                                    child: const Icon(
                                      Icons.remove,
                                      size: 15,
                                    ),
                                    onTap: _decrement,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(_quantity.toString(),
                                          style:
                                              const TextStyle(fontSize: 20))),
                                  InkWell(
                                    child: const Icon(
                                      Icons.add,
                                      size: 15,
                                    ),
                                    onTap: _increment,
                                  ),
                                ]),
                              ),
                              Text(
                                  "Ksh. ${(int.parse(widget.data["price"]) * _quantity)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black))
                            ])),
                    //Counter section end

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.data["description"].toString(),
                        //"A Henley shirt is a collarless pullover shirt, by a round neckline and a placket about 3 to 5 inches (8 to 13 cm) long and usually having 2–5 buttons.",
                        style: GoogleFonts.openSans()
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            _addToCart(widget.data["id"].toString());
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: const StadiumBorder()),
                          child: Row(
                            children: [
                              //Icon(Icons.shopping_basket),
                              Badge(
                                badgeContent: Text(
                                  _cart_items.toString(),
                                  //widget.cart.length.toString(),
                                  style: GoogleFonts.openSans().copyWith(
                                      fontSize: 10, color: AppColors.white),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.shopping_basket),
                                position:
                                    BadgePosition.topEnd(top: -6, end: -8),
                                badgeColor: Colors.red,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              _adding_to_cart
                                  ? Text("Adding to basket...")
                                  : Text(
                                      "Add to Basket",
                                      style: TextStyle(fontSize: 20),
                                    )
                              /*BigText(
                                text: "Add to Cart",
                                color: Colors.white,
                              )*/
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _addToCart(product_id) async {
    setState(() {
      //base_client.cart_change = true;
      _adding_to_cart = true;
    });

    final prefs = await SharedPreferences.getInstance();

    Map data = {
      "productId": product_id,
      "number": _quantity.toString(),
      "clientId": prefs.getString("client_id").toString()
    };

    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/cart/add",
        data,
        prefs.getString("token").toString());

    if (request_result["data"]["success"]) {
      setState(() {
        _cart_items += 1;
        _adding_to_cart = false;
      });

      _showSnackBar("Added to basket", Colors.green, Icons.done, Colors.white,
          Colors.white);
    }

    //print(request_result);
  }
}
