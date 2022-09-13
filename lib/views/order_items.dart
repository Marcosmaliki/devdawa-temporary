import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewOrdered extends StatefulWidget {
  final String order_id;

  List items;

  ViewOrdered({
    required this.order_id,
    required this.items,
  });
  @override
  _ViewOrderedState createState() => _ViewOrderedState();
}

class _ViewOrderedState extends State<ViewOrdered> {
  bool _fetchitems = true;

  var base_client = BaseClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrder();
  }

  _getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/order/items/${widget.order_id}/get",
        prefs.getString("token"));

    //print(request_result);

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        if (widget.items.length < 1) {
          setState(() {
            widget.items = request_result["data"]["data"]["data"];
            _fetchitems = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Ordered Items"),
      ),
      body: _fetchitems
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: widget.items.length,
                itemBuilder: (_, index) {
                  return Container(
                    color: AppColors.shade,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(widget.items[index]["item_product"]["name"]
                          .toString()),
                      subtitle: Text("Ksh " +
                          widget.items[index]["productPrice"].toString()),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
