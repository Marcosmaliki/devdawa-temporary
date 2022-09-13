import 'dart:io';

import 'package:devdawa/seller/finish_add_condition.dart';
import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPrescProduct extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;

  AddPrescProduct(
      {required this.user, required this.token, required this.business_id});
  @override
  _AddPrescProductState createState() => _AddPrescProductState();
}

class _AddPrescProductState extends State<AddPrescProduct> {
  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

  File? file;

  bool _fetch_category = true;
  bool _fetch_subcategory = true;
  bool _fetch_brand = true;
  bool _fetch_unit = true;
  bool _fetch_color = true;

  List categories = [];
  List subs = [];
  List brands = [];
  List units = [];
  List colors = [];

  List<String> categories_list = [];
  List<String> subs_list = [];
  List<String> brands_list = [];
  List<String> units_list = [];
  List<String> colors_list = [];

  String? category;
  String? subcat;
  String? brand;
  String? unit;
  String? color;

  String? categoryId;
  String? subId;
  String? brandId;
  String? unitId;
  String? colorId;

  bool _fetch_products = true;

  bool fetching_cart = true;

  bool _fetchingproductslist = true;

  List _products = [];

  Map details = {};

  String token = "";

  List<dynamic> cart = [];

  int _cart_counter = 0;

  bool _fetchingDetails = true;

  List products_list = [];

  bool _fetching_products = true;

  List prods = [];

  _fetchCategory() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/category/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_category = false;
          categories = request_result["data"]["data"]["data"];
        });

        for (var category in categories) {
          setState(() {
            categories_list.add(category["category"]);
          });
        }
      }
    }
  }

  _fetchSubCategory() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/subcategory/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_subcategory = false;
          subs = request_result["data"]["data"]["data"];
        });

        for (var subcategory in subs) {
          setState(() {
            subs_list.add(subcategory["subcategory"]);
          });
        }
      }
    }
  }

  _fetchBrands() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/brand/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_brand = false;
          brands = request_result["data"]["data"]["data"];
        });

        for (var br in brands) {
          setState(() {
            brands_list.add(br["brandName"]);
          });
        }
      }
    }
  }

  _fetchUnits() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/unit/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_unit = false;
          units = request_result["data"]["data"]["data"];
        });

        for (var unts in units) {
          setState(() {
            units_list.add(unts["unit"]);
          });
        }
      }
    }
  }

  _fetchColors() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/color/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_color = false;
          colors = request_result["data"]["data"]["data"];
        });

        for (var clrs in colors) {
          setState(() {
            colors_list.add(clrs["color"]);
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*_fetchCategory();
    _fetchSubCategory();
    _fetchBrands();
    _fetchUnits();
    _fetchColors();*/

    _fetchProducts();
  }

  _fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/product/business/${widget.business_id}/get",
        prefs.getString("token"));

    //print(request_result);

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_products = false;
//          prods = request_result["data"]["data"]["data"];
          _products = request_result["data"]["data"]["data"];
        });

        print(_products.length);

        //print(prods[0]["product_image"][0]["image"]);
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Add Condition Product"),
      ),
      body: _fetching_products
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
                          physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _products.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AddConditionProdFinish(
                                  user: widget.user,
                                  token: widget.token,
                                  business_id: widget.business_id,
                                  product_id: _products[index]["id"],
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
                          _products[index]["product_business"]["businessName"],
                          _products[index]["product_detail"]["details"],
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text("No Items"),
                ),
    );
  }

  Widget _productItem(String image, String name, String color, String brand,
      String seller, String description) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 155,
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
            height: 140,
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
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Add as condition product",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                )
                /*Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: IconLoadingButton(
                      color: AppColors.green,
                      iconColor: Colors.white,
                      valueColor: AppColors.green,
                      errorColor: const Color(0xffe0333c),
                      successColor: Colors.blue,
                      elevation: 1,
                      child: Text(
                        'Add as condition product',
                        style: GoogleFonts.openSans().copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      iconData: Icons.login,
                      onPressed: () {},
                      successIcon: Icons.check_circle_outline,
                      controller: _loadingBtnController,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path.toString());
      });
      /*_uploadImage(file);*/
      print(file!.path.toString());
    } else {
      // User canceled the picker
    }
  }

  _uploadImage(image) async {
    try {
      FormData formData = new FormData.fromMap({
        "image": await MultipartFile.fromFile(file!.path,
            filename: DateTime.now().millisecondsSinceEpoch.toString()),
      });

      Response response = await Dio().post(
          //"https://Dawasap-api.devsmart.co.ke/api/product/business/add/image",
          "https://api.dawasap.com/api/product/business/add/image",
          data: formData);

      _createProduct(response.toString());

      print(response);

      /*if (response.data["success"]) {
      } else {}*/

      //print("Done "+response.toString());

    } catch (e) {
      print(e);
    }
  }

  _createProduct(image) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "businessId": widget.business_id,
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/product/business/add", data);

    _loadingBtnController.reset();

    if (request_result["data"]["success"]) {
      _showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: SellerHome(
                user: widget.user,
                token: widget.token,
              ),
              inheritTheme: true,
              ctx: context),
        );
      });
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    print(request_result);
  }
}
