import 'dart:io';

import 'package:devdawa/seller/addprescproduct.dart';
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

class AddProduct extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;

  AddProduct(
      {required this.user, required this.token, required this.business_id});
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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
    _fetchCategory();
    _fetchSubCategory();
    _fetchBrands();
    _fetchUnits();
    _fetchColors();
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
        title: const Text("Add Product"),
        actions: [
          PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  final prefs = await SharedPreferences.getInstance();
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: AddPrescProduct(
                          token: widget.token,
                          user: widget.user,
                          business_id: widget.business_id,
                        ),
                        inheritTheme: true,
                        ctx: context),
                  );
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
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                            Text('Add prescription product')
                          ],
                        )),
                    /*PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                            Text('Add conditions')
                          ],
                        )),*/
                  ]),
        ],
      ),
      body: !_fetch_category &&
              !_fetch_brand &&
              !_fetch_unit &&
              !_fetch_color &&
              !_fetch_subcategory
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickFile();
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text(
                            file == null
                                ? "Choose product image"
                                : "Product Image Attached",
                            style: TextStyle(
                                color: file == null
                                    ? AppColors.black
                                    : AppColors.white,
                                fontWeight: FontWeight.w700),
                          )),
                          decoration: BoxDecoration(
                              color: file == null
                                  ? AppColors.grey
                                  : AppColors.green),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      DropDown(
                        items: categories_list,
                        hint: Text("Choose product category here"),
                        icon: Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            category = val.toString();
                          });

                          for (var cat in categories) {
                            if (cat["category"] == val.toString()) {
                              setState(() {
                                categoryId = cat["id"];
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDown(
                        items: subs_list,
                        hint: Text("Choose product sub-category"),
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
                        hint: Text("Choose product brand"),
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
                        hint: Text("Choose product unit"),
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
                        hint: Text("Choose product color"),
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
                                  category != null &&
                                  subcat != null &&
                                  brand != null &&
                                  unit != null &&
                                  color != null) {
                                if (file == null) {
                                  _loadingBtnController.reset();
                                  _showSnackBar(
                                      "Attach product image",
                                      Colors.amber,
                                      Icons.warning,
                                      Colors.black,
                                      Colors.black);
                                } else {
                                  _uploadImage(file);
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
        /*"file": await MultipartFile.fromFile(file!.path,
            filename: DateTime.now().millisecondsSinceEpoch.toString()),*/

        "image": await MultipartFile.fromFile(file!.path,
            filename: DateTime.now().millisecondsSinceEpoch.toString()),
      });

      Response response = await Dio()
          .post("https://api.dawasap.com/api/product/business/add/image",
              //"https://api.dawasap.com/api/product/business/add/image",
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
      "name": _nameController.text,
      "unitId": unitId,
      "brandId": brandId,
      "subcategoryId": subId,
      "averageRating": "0",
      "status": "1",
      "colorId": colorId,
      "inventory": _inventoryController.text.toString(),
      "images": image,
      "pricePerUnit": _unitpriceController.text.toString(),
      "price": _itempriceController.text.toString(),
      "discount": _discountController.text.toString(),
      "totalTax": _taxController.text.toString(),
      "details": _detailsController.text
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
