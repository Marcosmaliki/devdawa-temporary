import 'package:devdawa/seller/new_orders.dart';
import 'package:devdawa/seller/pending_prescs.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OrdersPrescriptions extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;
  final List orderslist;

  OrdersPrescriptions(
      {required this.user,
      required this.token,
      required this.business_id,
      required this.orderslist});
  @override
  _OrdersPrescriptionsState createState() => _OrdersPrescriptionsState();
}

class _OrdersPrescriptionsState extends State<OrdersPrescriptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Orders & Prescriptions"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: NewOrders(
                        user: widget.user,
                        token: widget.token,
                        business_id: widget.business_id,
                        orderslist: widget.orderslist,
                      ),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.shade),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/order.png"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("View new orders")
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                //print("Prescription");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PendingPrescs(
                          user: widget.user,
                          token: widget.token,
                          business_id: widget.business_id,
                        )));
                /*Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: PendingPrescs(),
                      inheritTheme: true,
                      ctx: context),
                );*/
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.shade),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/presc.png"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("View prescriptions")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
