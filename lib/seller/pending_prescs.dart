import 'package:devdawa/seller/accepted_prescs.dart';
import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingPrescs extends StatefulWidget {
  final Map user;
  final String token;
  final String business_id;

  PendingPrescs({
    required this.user,
    required this.token,
    required this.business_id,
  });
  @override
  _PendingPrescsState createState() => _PendingPrescsState();
}

class _PendingPrescsState extends State<PendingPrescs> {
  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

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
        base_client.base_url + "/prescription/get/pending",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Prescriptions"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: AcceptedPrescs(
                      user: widget.user,
                      token: widget.token,
                      business_id: widget.business_id,
                    ),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            child: Container(
              height: 30,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.purple[400],
              ),
              child: Center(
                child: Text("View Accepted Prescriptions"),
              ),
            ),
          )
        ],
      ),
      body: _fetching_prescs
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _prescs.length,
                itemBuilder: (_, index) {
                  return _prescItem(
                      _prescs[index]["image"],
                      _prescs[index]["claimForm"],
                      _prescs[index]["special_instructions"].toString(),
                      _prescs[index]["id"].toString());
                },
              ),
            ),
    );
  }

  Widget _prescItem(prescription, claimform, instructions, id) {
    return Expanded(
      child: Container(
        //height: 300,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.shade, borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: GalleryImage(
                imageUrls: [prescription, claimform],
              )),
              /*Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 150,
                      color: AppColors.white,
                      margin: EdgeInsets.all(5),
                      child: Image.network(
                        prescription,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 150,
                      color: AppColors.white,
                      margin: EdgeInsets.all(5),
                      child: Image.network(
                        claimform,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),*/
              SizedBox(
                height: 5,
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    instructions,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
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
                          'Accept this prescription',
                          style: GoogleFonts.openSans().copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        iconData: Icons.login,
                        onPressed: () {
                          _acceptPrescription(id);
                        },
                        successIcon: Icons.check_circle_outline,
                        controller: _loadingBtnController,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
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

  _acceptPrescription(presc_id) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "businessId": widget.business_id,
      "id": presc_id,
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/prescription/accept", data);

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
