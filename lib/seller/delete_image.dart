import 'package:devdawa/seller/seller_home.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteImage extends StatefulWidget {
  final String token;
  final String image_id;
  final String image;
  final Map user;
  const DeleteImage({
    Key? key,
    required this.token,
    required this.image_id,
    required this.image,
    required this.user,
  }) : super(key: key);
  @override
  _DeleteImageState createState() => _DeleteImageState();
}

class _DeleteImageState extends State<DeleteImage> {
  var base_client = BaseClient();

  final IconButtonController _loadingBtnController = IconButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "Delete Image",
          style: GoogleFonts.openSans().copyWith(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.image,
                  //product_images[_imageIndex]["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: IconLoadingButton(
                  color: AppColors.red,
                  iconColor: Colors.white,
                  valueColor: AppColors.green,
                  errorColor: const Color(0xffe0333c),
                  successColor: Colors.blue,
                  elevation: 1,
                  child: Text(
                    'Delete',
                    style: GoogleFonts.openSans().copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  iconData: Icons.login,
                  onPressed: () {
                    _deleteImage();
                  },
                  successIcon: Icons.delete,
                  controller: _loadingBtnController,
                ),
              ),
            ),
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

  _deleteImage() async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "imageId": widget.image_id,
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/product/business/edit/images", data);

    print(request_result);

    _loadingBtnController.reset();

    if (!request_result["data"]["success"]) {
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
