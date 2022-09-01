import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BaseClient {
  //String base_url = "https://Dawasap-api.devsmart.co.ke/api";

  String base_url = "https://api.dawasap.com/api";

  bool cart_change = false;

  sharedPrefences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static getRequest(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
      });
      var converted = json.decode(response.body);
      return {
        "status": "good",
        "response": response.statusCode,
        "data": converted
      };
    } on SocketException {
      return {"status": "offline"};
    } on TimeoutException {
      return {"status": "timeout"};
    }
  }

  static postRequest(String url, Map data) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: {"Accept": "application/json"}, body: data);
      var converted = json.decode(response.body);
      return {
        "status": "good",
        "response": response.statusCode,
        "data": converted
      };
    } on SocketException {
      return {"status": "offline"};
    } on TimeoutException {
      return {"status": "timeout"};
    }
  }

  static postRequestOrg(String url, Map data, String auth_string) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "X-Api-Request": "v1",
            "Authorization": 'Bearer $auth_string'
          },
          body: data);
      var converted = json.decode(response.body);
      return {
        "status": "good",
        "response": response.statusCode,
        "data": converted
      };
    } on SocketException {
      return {"status": "offline"};
    } on TimeoutException {
      return {"status": "timeout"};
    }
  }

  static putRequestOrg(String url, Map data, String auth_string) async {
    try {
      http.Response response = await http.put(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "X-Api-Request": "v1",
            "Authorization": 'Bearer $auth_string'
          },
          body: data);
      var converted = json.decode(response.body);
      return {
        "status": "good",
        "response": response.statusCode,
        "data": converted
      };
    } on SocketException {
      return {"status": "offline"};
    } on TimeoutException {
      return {"status": "timeout"};
    }
  }

  static getRequestAuth(String url, auth_string) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "X-Api-Request": "v1",
        "Authorization": "Bearer $auth_string"
      });
      var converted = json.decode(response.body);
      return {
        "status": "good",
        "response": response.statusCode,
        "data": converted
      };
    } on SocketException {
      return {"status": "offline"};
    } on TimeoutException {
      return {"status": "timeout"};
    }
  }
}
