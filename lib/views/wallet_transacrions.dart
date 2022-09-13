import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletTransactions extends StatefulWidget {
  final Map user;
  final String token;
  final String walletId;

  WalletTransactions(
      {required this.user, required this.token, required this.walletId});

  @override
  _WalletTransactionsState createState() => _WalletTransactionsState();
}

class _WalletTransactionsState extends State<WalletTransactions> {
  var base_client = BaseClient();

  bool _fetching_trans = true;

  List _trans = [];

  _getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/wallet/transactions/${widget.walletId}",
        prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetching_trans = false;
          _trans = request_result["data"]["data"]["data"];
        });

        //print(orders);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Wallet Balance"),
      ),
      body: _fetching_trans
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
                itemCount: _trans.length,
                itemBuilder: (_, index) {
                  return _transItem(
                      _trans[index]["reference"].toString(),
                      _trans[index]["amount"].toString(),
                      _trans[index]["created_at"].toString());
                },
              ),
            ),
    );
  }

  Widget _transItem(code, amount, datetime) {
    return Container(
      height: 85,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.shade),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text("Reference: "),
                SizedBox(
                  width: 5,
                ),
                Text(code),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text("Amount: "),
                SizedBox(
                  width: 5,
                ),
                Text(amount),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text("Date: "),
                SizedBox(
                  width: 5,
                ),
                Text(datetime),
              ],
            )
          ],
        ),
      ),
    );
  }
}
