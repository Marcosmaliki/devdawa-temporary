import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/prooduct_detail.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  final Map user;
  final String token;

  Search({required this.user, required this.token});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  String check = "";
  double _cardheight = 70;
  List data_list = [];
  bool search = false;
  Map? mapdata;
  double _height = 0;
  bool? logged;

  String user_type = "";

  var base_client = BaseClient();

  List<dynamic> cart = [];

  late InfiniteScrollController _carouselController;

  bool _fetchingproducts = true;
  bool _fetchingDetails = true;

  int _cart_counter = 0;

  bool _fetch_categories = false;
  bool _fetch_brands = false;
  List _categories = [];
  List _brands_list = [];

  List products_list = [];

  bool fetching_cart = true;

  Map details = {};

  String token = "";

  @override
  void initState() {
    super.initState();
    _getProducts();
    _getCart();
    _getDetails();
    _getCategories();
    _getBrands();
  }

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
        base_client.base_url + "/product/all", prefs.getString("token"));

    for (var product in request_result["data"]["data"]["data"]) {
      products_list.add({
        "id": product["id"],
        "name": product["name"],
        /*"image": product["product_image"][0]["image"],*/
        "image": product["product_image"],
        "price": product["product_pricing"]["price"].toString(),
        "rating": "3",
        "description": product["product_detail"]["details"],
        "stock": product["inventory"]
      });
    }

    setState(() {
      _fetchingproducts = false;
    });

    print(products_list);

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

  void searchItem(String text) async {
    data_list.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (text.length == 0) {
      _height = 0;
    } else {
      var request_result = await BaseClient.getRequestAuth(
          base_client.base_url + "/product/all?name=${text.toString()}",
          prefs.getString("token"));

      setState(() {
        search = false;
      });

      print(request_result);

      for (var data in request_result["data"]["data"]["data"]) {
        data_list.add(data);
      }

      /*var converted = json.decode(response.body);
      for (var i = 0; i < converted.length; i++) {
        mapdata = converted[i];
        if (!data_list.toString().contains(mapdata.toString())) {
          data_list.add(mapdata);
        }
      }*/
    }

    //print("Data List is " + data_list.toString());

    if (text.length > 0) {
      setState(() {
        _height = 200;
      });
    } else if (text.length == 0) {
      setState(() {
        _height = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: TextField(
          cursorHeight: 20,
          autofocus: false,
          cursorColor: AppColors.black,
          controller: _searchController,
          onChanged: (query) {
            data_list.clear();
            setState(() {
              search = true;
              check = query;
            });
            if (search) {
              searchItem(query);
            }
          },
          decoration: InputDecoration(
            filled: true,
            //labelText: 'search',
            fillColor: AppColors.shade,
            hintText: "Search Item",
            labelStyle: TextStyle(color: AppColors.white),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade500,
            ),
            suffixIcon: Icon(
              Icons.cancel,
              color: Colors.grey.shade500,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: 0.0,
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: AppColors.white, width: 1.5),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: data_list.length,
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProductDetail(
                        token: token,
                        cart_count: cart.length,
                        user: details,
                        data: {
                          "id": data_list[index]["id"].toString(),
                          "name": data_list[index]["name"].toString(),
                          "image": data_list[index]["product_image"],
                          /*"image": data_list[index]["product_image"][0]["image"]
                              .toString(),*/
                          "price": data_list[index]["product_pricing"]["price"]
                              .toString(),
                          "rating": "3",
                          "description": data_list[index]["product_detail"]
                              ["details"],
                          "stock": data_list[index]["inventory"].toString()
                        },
                        cart: cart,
                      ),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: AppColors.white,
                margin: EdgeInsets.all(2),
                child: ListTile(
                  /*onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ProductDetail(
                            token: token,
                            cart_count: cart.length,
                            user: details,
                            data: {
                              "id": data_list[index]["id"].toString(),
                              "name": data_list[index]["name"].toString(),
                              "image": data_list[index]["product_image"],
                              */ /*"image": data_list[index]["product_image"][0]["image"]
                              .toString(),*/ /*
                              "price": data_list[index]["product_pricing"]
                                      ["price"]
                                  .toString(),
                              "rating": "3",
                              "description": data_list[index]["product_detail"]
                                  [0]["details"],
                              "stock": data_list[index]["inventory"].toString()
                            },
                            cart: cart,
                          ),
                          inheritTheme: true,
                          ctx: context),
                    );
                  },*/
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  leading: Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        color: Colors.white,
                        child: Image.network(
                          data_list[index]["product_image"][0]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    data_list[index]["name"],
                    style: TextStyle(
                        color: Color(0xff7e0202), fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Number in stock: ${data_list[index]["inventory"].toString()}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
            return GestureDetector(
              onTap: () {
                print("Pushing something");
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProductDetail(
                        token: token,
                        cart_count: cart.length,
                        user: details,
                        data: {
                          "id": data_list[index]["id"].toString(),
                          "name": data_list[index]["name"].toString(),
                          /*"image": product["product_image"][0]["image"],*/
                          "image": data_list[index]["product_image"][0]["image"]
                              .toString(),
                          "price": data_list[index]["product_pricing"]["price"]
                              .toString(),
                          "rating": "3",
                          "description": data_list[index]["product_detail"]
                              ["details"],
                          "stock": data_list[index]["inventory"].toString()
                        },
                        cart: cart,
                      ),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Container(
                child: _productWidget(
                  data_list[index]["id"].toString(),
                  data_list[index]["name"],
                  data_list[index]["product_image"][0]["image"],
                  data_list[index]["inventory"].toString(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _productWidget(
    String id,
    String name,
    String image,
    String inventory,
  ) {
    //print(productList);
    return Container(
      margin: EdgeInsets.all(1),
      height: _cardheight,
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 7),
              child: Hero(
                tag: id,
                child: ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  leading: Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        color: Colors.white,
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                        /*child: status == 1
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                              )
                            : Opacity(
                                opacity: 0.2,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),*/
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                        color: Color(0xff7e0202), fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Number in stock: ${inventory.toString()}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  /*subtitle: status == 1
                      ? Text(
                          "Price: ${price.toString()}\nIn Stock: ${stock.toString()}",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Price: ${price.toString()}\nOut of stock",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),*/
                  trailing: GestureDetector(
                      child: GestureDetector(
                    child: Icon(Icons.arrow_forward),
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                    },
                  )),
                ),
              ),
            ),
            /*Divider(
              color: Colors.grey[200],
            )*/
          ],
        ),
      ),
    );
  }
}
