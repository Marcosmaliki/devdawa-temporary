import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:devdawa/models/categories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ViewCategories extends GetxController {
  List<Categories> categories_list = <Categories>[].obs;
  var url = "http://grocery.cnwuniversals.com/getcategories/cnw";

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  getCategories() async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
      });
      var converted = json.decode(response.body);
      print(converted);
    } on SocketException {
      print("Offline");
      //return {"status": "offline"};
    } on TimeoutException {
      print("Request timeout");
      //return {"status": "timeout"};
    }
  }
}
