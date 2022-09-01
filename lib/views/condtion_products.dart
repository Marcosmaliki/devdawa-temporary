import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/category_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConditionsProducts extends StatefulWidget {
  final String condition;
  final String condition_id;

  ConditionsProducts({
    required this.condition,
    required this.condition_id,
  });

  @override
  _ConditionsProductsState createState() => _ConditionsProductsState();
}

class _ConditionsProductsState extends State<ConditionsProducts> {
  List products_list = [];

  List<dynamic> cart = [];

  Map details = {};

  String token = "";

  late InfiniteScrollController _carouselController;

  bool _fetchingproducts = true;
  bool _fetchingDetails = true;

  bool fetching_cart = true;

  var base_client = BaseClient();

  int _cart_counter = 0;

  bool _fetch_categories = false;
  bool _fetch_brands = false;
  List _categories = [];
  List _brands_list = [];

  bool _fetch_products = true;
  bool _fetchingproductslist = true;
  List _products = [];

  _getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/category/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_categories = false;
          _categories = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  _getBrands() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/brand/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_brands = false;
          _brands_list = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _carouselController.dispose();
  }

  _getCart() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/cart/all", prefs.getString("token"));

    setState(() {
      cart = request_result["data"]["data"]["data"];
      _cart_counter = request_result["data"]["data"]["data"].length;
      fetching_cart = false;
    });

    //print(request_result["data"]["data"]["data"].length);
  }

  _getProducts() async {
    final prefs = await SharedPreferences.getInstance();

    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/condition/${widget.condition_id}/products",
        prefs.getString("token"));

    _products = request_result["data"]["data"]["data"];

    for (var product in request_result["data"]["data"]["data"]) {
      products_list.add({
        "id": product["id"],
        "name": product["name"],
        "image": product["product_image"][0]["image"],
        "price": product["product_pricing"]["price"].toString(),
        "rating": "3",
        "description": product["product_detail"]["details"],
        "stock": product["inventory"]
      });
    }

    setState(() {
      _fetchingproducts = false;
    });
  }

  /*_getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/product/category/${widget.category_id}/get",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_products = false;
          _products = request_result["data"]["data"]["data"];

          for (var product in _products) {
            products_list.add({
              "id": product["id"],
              "name": product["name"],
              "image": product["product_image"][0]["image"],
              "price": product["product_pricing"]["price"].toString(),
              "rating": "3",
            });
          }
        });
      }
    }

  }*/

  _getProductsList() async {
    final prefs = await SharedPreferences.getInstance();

    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/condition/${widget.condition_id}/products",
        prefs.getString("token"));

    for (var product in request_result["data"]["data"]["data"]) {
      products_list.add({
        "id": product["id"],
        "name": product["name"],
        "image": product["product_image"][0]["image"],
        "price": product["product_pricing"]["price"].toString(),
        "rating": "3",
        "description": product["product_detail"]["details"],
        //"description": "hello",
        "stock": product["inventory"].toString(),
        //"stock": "hey"
      });
    }

    setState(() {
      _fetchingproductslist = false;
    });

    //print(products_list);

    //popular_items
  }

  _getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/user/${prefs.getString("user_uid")}/get",
        prefs.getString("token"));

    setState(() {
      token = prefs.getString("token").toString();
      details = request_result["data"]["data"];
      _fetchingDetails = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
    _getCart();
    _getDetails();
    _getCategories();
    _getBrands();
    _getProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            "Condition Products",
            style: GoogleFonts.openSans().copyWith(),
          ),
        ),
        body: _fetch_brands ||
                _fetchingproducts ||
                fetching_cart ||
                _fetchingDetails ||
                _fetch_categories
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _products.length > 0
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            //print(cart);
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CategoryDetail(
                                    token: token,
                                    cart_count: cart.length,
                                    user: details,
                                    data: products_list[index],
                                    cart: cart,
                                  ),
                                  inheritTheme: true,
                                  ctx: context),
                            );
                          },
                          child: _productItem(
                            _products[index]["product_image"][0]["image"],
                            _products[index]["name"],
                            _products[index]["product_color"]["color"],
                            _products[index]["inventory"],
                            _products[index]["product_business"]
                                ["businessName"],
                            _products[index]["product_detail"]["details"],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text("No Items"),
                  ));
  }

  Widget _productItem(String image, String name, String color, String brand,
      String seller, String description) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
          color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: 90,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  image.toString(),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 90,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: AppColors.grey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3,
                ),
                Text(
                  name.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.green),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  color,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Number in stock:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(brand),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Seller:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(seller),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
