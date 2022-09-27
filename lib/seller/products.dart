import 'package:devdawa/seller/add_product.dart';
import 'package:devdawa/seller/delete_image.dart';
import 'package:devdawa/seller/edit_product.dart';
import 'package:devdawa/seller/new_orders.dart';
import 'package:devdawa/seller/orders_prescriptions.dart';
import 'package:devdawa/seller/pending_prescs.dart';
import 'package:devdawa/seller/prescriptions.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/prescription.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProducts extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;

  BusinessProducts(
      {required this.user, required this.token, required this.business_id});

  @override
  _BusinessProductsState createState() => _BusinessProductsState();
}

class _BusinessProductsState extends State<BusinessProducts> {
  var base_client = BaseClient();

  bool _fetching_products = true;

  List prods = [];

  bool _fetching_orders = true;

  bool _fetching_prescs = true;

  List orders = [];
  List _prescs = [];

  int _imageIndex = 0;

  _fetchPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/prescription/${widget.business_id}/all",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_prescs = false;
          _prescs = request_result["data"]["data"]["data"];
        });

        //print(orders);
      }
    }
  }

  _fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/product/business/${widget.business_id}/get",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_products = false;
          prods = request_result["data"]["data"]["data"];
        });

        print(prods);

        //print(prods[0]["product_image"][0]["image"]);
      }
    }
  }

  _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/order/business/${widget.business_id}/get",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_orders = false;
          orders = request_result["data"]["data"]["data"];
        });

        //print(orders);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
    _fetchOrders();
    _fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        //title: const Text("Products"),
        actions: [
          SizedBox(
            width: 10,
          ),
          Container(
            width: 250,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: OrdersPrescriptions(
                            user: widget.user,
                            token: widget.token,
                            business_id: widget.business_id,
                            orderslist: orders,
                          ),
                          inheritTheme: true,
                          ctx: context),
                    );

                    /*if (orders.length > 0) {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: NewOrders(
                              user: widget.user,
                              token: widget.token,
                              business_id: widget.business_id,
                              orderslist: orders,
                            ),
                            inheritTheme: true,
                            ctx: context),
                      );
                    }*/
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _fetching_orders
                                    ? "..."
                                    : orders.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "New orders",
                                style: TextStyle(color: AppColors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _fetching_products || _fetching_orders || _fetching_prescs
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : prods.length < 1
              ? Container(
                  child: Center(
                    child: Text("No products"),
                  ),
                )
              : Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: prods.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: _listItem(
                              prods[index]["name"].toString(),
                              prods[index]["product_image"][
                                      prods[index]["product_image"].length -
                                          1]["image"]
                                  .toString(),
                              prods[index]["product_subcategory"]["subcategory"]
                                  .toString(),
                              prods[index]["product_detail"]["details"]
                                  .toString(),
                              prods[index]["product_pricing"]["price"]
                                  .toString(),
                              prods[index]["product_unit"]["unit"].toString(),
                              prods[index]["product_color"]["color"].toString(),
                              prods[index]["product_brand"]["brandName"]
                                  .toString(),
                              prods[index],
                              prods[index]["product_image"]),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: AddProduct(
                  user: widget.user,
                  token: widget.token,
                  business_id: widget.business_id,
                ),
                inheritTheme: true,
                ctx: context),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listItem(name, image, subcat, details, price, unit, color, brand,
      product, product_images) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 470,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      //product_images[_imageIndex]["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              //margin: EdgeInsets.only(left: 0, right: 20),
              decoration: BoxDecoration(color: AppColors.grey),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: product_images.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      /*setState(() {
                        _imageIndex = index;
                      });*/
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: DeleteImage(
                              user: widget.user,
                              image_id: product_images[index]["id"].toString(),
                              image: product_images[index]["image"].toString(),
                              token: widget.token,
                            ),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product_images[index]["image"].toString(),
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Name: "),
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Subcategory: "),
                Text(
                  subcat,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Price: "),
                Text(
                  price,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Unit: "),
                Text(
                  unit,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Color: "),
                Text(
                  color,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Brand: "),
                Text(
                  brand,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: EditProduct(
                        user: widget.user,
                        token: widget.token,
                        business_id: widget.business_id,
                        product: product,
                      ),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text("Edit product"),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
