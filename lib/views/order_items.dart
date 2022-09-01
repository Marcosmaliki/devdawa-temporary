import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class ViewOrdered extends StatefulWidget {
  final String order_id;

  final List items;

  ViewOrdered({
    required this.order_id,
    required this.items,
  });
  @override
  _ViewOrderedState createState() => _ViewOrderedState();
}

class _ViewOrderedState extends State<ViewOrdered> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Ordered Items"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (_, index) {
            return Container(
              color: AppColors.shade,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                    widget.items[index]["item_product"]["name"].toString()),
                subtitle: Text(
                    "Ksh. " + widget.items[index]["productPrice"].toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}
