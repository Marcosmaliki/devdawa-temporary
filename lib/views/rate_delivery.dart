import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDelivery extends StatefulWidget {
  final String token;
  final String deliverer_id;
  final String order_id;

  RateDelivery(
      {required this.token,
      required this.deliverer_id,
      required this.order_id});
  @override
  _RateDeliveryState createState() => _RateDeliveryState();
}

class _RateDeliveryState extends State<RateDelivery> {
  double rating = 0.0;

  String? rated;

  bool _rating = false;

  var base_client = BaseClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "Rate Us",
          style: GoogleFonts.openSans().copyWith(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please Rate The Driver"),
            SizedBox(
              height: 10,
            ),
            SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  rating = v;
                  setState(() {
                    rated = v.toString();
                  });
                },
                starCount: 5,
                rating: rating,
                size: 40.0,
                filledIconData: Icons.blur_off,
                halfFilledIconData: Icons.blur_on,
                color: Colors.green,
                borderColor: Colors.green,
                spacing: 0.0),
            SizedBox(
              height: 10,
            ),
            rated != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = true;
                      });
                      _rateDriver(widget.deliverer_id, widget.order_id);
                      /*Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CheckOutScreen(),
                                  inheritTheme: true,
                                  ctx: context),
                            );*/
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50,
                        width: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.green,
                        ),
                        child: Center(
                          child: _rating
                              ? Text(
                                  "Processing...",
                                  style: TextStyle(color: AppColors.white),
                                )
                              : Text(
                                  "Submit",
                                  //"Check Out",
                                  style: GoogleFonts.openSans().copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                        )),
                  )
                : SizedBox(),
          ],
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

  _rateDriver(String driver_id, String order_id) async {
    setState(() {
      _rating = true;
    });
    final prefs = await SharedPreferences.getInstance();
    Map data = {"deliverer": driver_id, "rating": rating.toString()};
    var request_result = await BaseClient.postRequestOrg(
        base_client.base_url + "/review/deliverer/rating",
        data,
        prefs.getString("token").toString());

    print(request_result);

    setState(() {
      _rating = false;
    });

    if (request_result["data"]["success"]) {
      _showSnackBar(
          "Done", Colors.green, Icons.done, Colors.white, Colors.white);

      /*Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: HomeScreen(
                token: widget.token,
              ),
              inheritTheme: true,
              ctx: context),
        );
      });*/
    } else if (request_result["response"].toString() == "500") {
      _showSnackBar("Server error(500)", Colors.red, Icons.error_outline,
          Colors.white, Colors.white);
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error_outline,
          Colors.white, Colors.white);
    }
  }
}
