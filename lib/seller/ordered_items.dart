import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class OrderedItems extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;
  final List itemslist;

  OrderedItems(
      {required this.user,
      required this.token,
      required this.business_id,
      required this.itemslist});

  @override
  _OrderedItemsState createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Order Items"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.itemslist.length,
          itemBuilder: (_, index) {
            return _orderItem(
                widget.itemslist[index]["item_product"]["name"],
                widget.itemslist[index]["item_product"]["inventory"].toString(),
                /*widget.itemslist[index]["quantity"].toString()*/
                widget.itemslist.length.toString());
          },
        ),
      ),
    );
  }

  Widget _orderItem(String name, String inventory, String count) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.shade),
        child: Padding(
          padding: EdgeInsets.only(top: 5, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Item: "),
                  Text(
                    name.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Inventory: "),
                  Text(
                    inventory.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("Order count: "),
                  Text(
                    count.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
