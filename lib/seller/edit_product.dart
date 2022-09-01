import 'dart:io';

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

class EditProduct extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;
  final Map product;

  EditProduct(
      {required this.user,
      required this.token,
      required this.business_id,
      required this.product});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

  File? file;

  bool _fetch_category = true;
  bool _fetch_subcategory = true;
  bool _fetch_brand = true;
  bool _fetch_unit = true;
  bool _fetch_color = true;

  bool _doing_colors = true;

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _inventoryController = TextEditingController();
  final TextEditingController _unitpriceController = TextEditingController();
  final TextEditingController _itempriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

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

    setState(() {
      subcat = widget.product["product_subcategory"]["subcategory"];
      brand = widget.product["product_brand"]["brandName"];
      unit = widget.product["product_unit"]["unit"];
      color = widget.product["product_color"]["color"];
      _nameController.text = widget.product["name"];
      _inventoryController.text = widget.product["inventory"].toString();
      _unitpriceController.text =
          widget.product["product_pricing"]["pricePerUnit"].toString();
      _itempriceController.text =
          widget.product["product_pricing"]["price"].toString();
      _discountController.text =
          widget.product["product_pricing"]["discount"].toString();
      _taxController.text =
          widget.product["product_pricing"]["totalTax"].toString();
      _detailsController.text =
          widget.product["product_detail"]["details"].toString();
    });

    _fetchCategory();
    _fetchSubCategory();
    _fetchBrands();
    _fetchUnits();
    _fetchColors();

    setState(() {
      _doing_colors = false;
    });
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
        title: const Text("Edit Product"),
      ),
      body: !_fetch_category &&
              !_fetch_brand &&
              !_fetch_unit &&
              !_fetch_color &&
              !_fetch_subcategory &&
              !_doing_colors
          ? Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: file == null
                                  ? Image.network(
                                      /*widget.product["product_image"][0]
                                          ["image"],*/
                                      widget.product["product_image"][widget
                                              .product["product_image"].length -
                                          1]["image"],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(File(file!.path)),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  _pickFile();
                                },
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.pink,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDown(
                        items: subs_list,
                        hint: Text(subcat.toString()),
                        icon: Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            subcat = val.toString();
                          });

                          for (var sb in subs) {
                            if (sb["subcategory"] == val.toString()) {
                              setState(() {
                                subId = sb["id"];
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDown(
                        items: brands_list,
                        hint: Text(brand.toString()),
                        icon: Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            brand = val.toString();
                          });

                          for (var bd in brands) {
                            if (bd["brandName"] == val.toString()) {
                              setState(() {
                                brandId = bd["id"];
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDown(
                        items: units_list,
                        hint: Text(unit.toString()),
                        icon: Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            unit = val.toString();
                          });

                          for (var un in units) {
                            if (un["unit"] == val.toString()) {
                              setState(() {
                                unitId = un["id"];
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDown(
                        items: colors_list,
                        hint: Text(color.toString()),
                        icon: Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            color = val.toString();
                          });

                          for (var cl in colors) {
                            if (cl["color"] == val.toString()) {
                              setState(() {
                                colorId = cl["id"];
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Product name",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _inventoryController,
                          decoration: InputDecoration(
                            labelText: "Inventory count",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _unitpriceController,
                          decoration: InputDecoration(
                            labelText: "Price per unit",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _itempriceController,
                          decoration: InputDecoration(
                            labelText: "Item price",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _discountController,
                          decoration: InputDecoration(
                            labelText: "Discount",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _taxController,
                          decoration: InputDecoration(
                            labelText: "Total tax",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 20,
                          controller: _detailsController,
                          decoration: InputDecoration(
                            labelText: "Item description & details",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          //keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
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
                              'Submit',
                              style: GoogleFonts.openSans().copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            iconData: Icons.login,
                            onPressed: () {
                              if (_nameController.text.isNotEmpty &&
                                  _inventoryController.text.isNotEmpty &&
                                  _unitpriceController.text.isNotEmpty &&
                                  _itempriceController.text.isNotEmpty &&
                                  _discountController.text.isNotEmpty &&
                                  _taxController.text.isNotEmpty &&
                                  _detailsController.text.isNotEmpty &&
                                  //category != null &&
                                  subcat != null &&
                                  brand != null &&
                                  unit != null &&
                                  color != null) {
                                if (file == null) {
                                  _dontUploadWithImage(widget
                                      .product["product_image"][0]["image"]);
                                } else {
                                  _uploadWithImage(file);
                                }
                              } else {
                                _loadingBtnController.reset();
                                _showSnackBar(
                                    "All fields are mandatory",
                                    Colors.amber,
                                    Icons.warning,
                                    Colors.black,
                                    Colors.black);
                              }
                            },
                            successIcon: Icons.check_circle_outline,
                            controller: _loadingBtnController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  _uploadWithImage(image) async {
    try {
      FormData formData = new FormData.fromMap({
        "image": await MultipartFile.fromFile(file!.path,
            filename: DateTime.now().millisecondsSinceEpoch.toString()),
      });

      Response response = await Dio().post(
          //"https://Dawasap-api.devsmart.co.ke/api/product/business/add/image",
          "https://api.dawasap.com/api/product/business/add/image",
          data: formData);

      print(response);

      _editProductWithImage(response.toString());
    } catch (e) {
      print(e);
    }
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

  _editProductWithImage(image) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "productId": widget.product["id"],
      "name": _nameController.text,
      "unitId": widget.product["unitId"],
      "brandId": widget.product["brandId"],
      "subcategoryId": widget.product["subcategoryId"],
      "averageRating": "0",
      "status": "1",
      "colorId": widget.product["colorId"],
      "inventory": _inventoryController.text.toString(),
      "images": image,
      "pricePerUnit": _unitpriceController.text.toString(),
      "price": _itempriceController.text.toString(),
      "discount": _discountController.text.toString(),
      "totalTax": _taxController.text.toString(),
      "details": _detailsController.text
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/product/business/edit", data);

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
  }

  _dontUploadWithImage(image) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "productId": widget.product["id"],
      "name": _nameController.text,
      "unitId": widget.product["unitId"],
      "brandId": widget.product["brandId"],
      "subcategoryId": widget.product["subcategoryId"],
      "averageRating": "0",
      "status": "1",
      "colorId": widget.product["colorId"],
      "inventory": _inventoryController.text.toString(),
      "images": image,
      "pricePerUnit": _unitpriceController.text.toString(),
      "price": _itempriceController.text.toString(),
      "discount": _discountController.text.toString(),
      "totalTax": _taxController.text.toString(),
      "details": _detailsController.text
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/product/business/edit", data);

    print(request_result);

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
  }
}
