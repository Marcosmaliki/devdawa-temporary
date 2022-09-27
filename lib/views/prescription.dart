import 'dart:io';

import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/home.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_loading_button/icon_loading_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prescription extends StatefulWidget {
  /*final Map user;
  final String token;

  Prescription({required this.user, required this.token});*/

  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final TextEditingController _detailsController = TextEditingController();
  final IconButtonController _loadingBtnController = IconButtonController();
  var base_client = BaseClient();

  File? presc_file;
  File? claim_file;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Submit Prescription"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _pickPrescFile();
              },
              child: Container(
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                  color: presc_file == null ? AppColors.grey : AppColors.green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      presc_file == null
                          ? Icons.open_in_new
                          : Icons.check_circle_outline,
                      color: presc_file == null
                          ? AppColors.black
                          : AppColors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      presc_file == null
                          ? "Select prescription"
                          : "Prescription selected",
                      style: TextStyle(
                          color: presc_file == null
                              ? AppColors.black
                              : AppColors.white),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _pickClaimFile();
              },
              child: Container(
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                  color: claim_file == null ? AppColors.grey : AppColors.green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      claim_file == null
                          ? Icons.open_in_new
                          : Icons.check_circle_outline,
                      color: claim_file == null
                          ? AppColors.black
                          : AppColors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      claim_file == null
                          ? "Select claim form(Optional)"
                          : "Claim form selected",
                      style: TextStyle(
                          color: claim_file == null
                              ? AppColors.black
                              : AppColors.white),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: "Special Intructions(Optional)",
                  fillColor: AppColors.shade,
                  /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(),
                  ),*/
                  //fillColor: Colors.green
                ),
                //keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            presc_file != null
                ? Container(
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
                          'Upload and submit',
                          style: GoogleFonts.openSans().copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        iconData: Icons.login,
                        onPressed: () {
                          /*if (_detailsController.text.isNotEmpty) {
                            _uploadPrecFile(presc_file);
                          } else {
                            _showSnackBar(
                                "Please include special instructions",
                                Colors.red,
                                Icons.error,
                                Colors.white,
                                Colors.white);
                          }*/
                          _uploadPrecFile(presc_file);
                        },
                        successIcon: Icons.check_circle_outline,
                        controller: _loadingBtnController,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),

            /*presc_file != null && claim_file != null
                ? GestureDetector(
                    onTap: () {
                      if (_detailsController.text.isNotEmpty) {
                        _uploadPrecFile(presc_file);
                      } else {
                        _showSnackBar(
                            "Please include special instructions",
                            Colors.red,
                            Icons.error,
                            Colors.white,
                            Colors.white);
                      }
                    },
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(color: AppColors.grey),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: AppColors.green),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Upload and submit",
                            style: TextStyle(color: AppColors.green),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),*/
          ],
        ),
      ),
    );
  }

  _uploadPrecFile(image) async {
    try {
      FormData formData = new FormData.fromMap({
        "images": await MultipartFile.fromFile(presc_file!.path,
            filename: DateTime.now().millisecondsSinceEpoch.toString()),
      });

      Response response = await Dio().post(
          //"https://Dawasap-api.devsmart.co.ke/api/product/business/add/image",
          "https://api.dawasap.com/api/prescription/upload-files",
          data: formData);

      if (claim_file != null) {
        _uploadClaimFile(response.toString());
      } else {
        _uploadFullPrescription(response.toString(), "no data");
      }

      print("Response is " + response.toString());

      /*if (response.data["success"]) {
      } else {}*/

      //print("Done "+response.toString());

    } catch (e) {
      print(e);
    }
  }

  _uploadClaimFile(String presc_url) async {
    try {
      FormData formData = new FormData.fromMap({
        "images": await MultipartFile.fromFile(claim_file!.path,
            filename: DateTime.now().millisecondsSinceEpoch.toString()),
      });

      Response response = await Dio().post(
          //"https://Dawasap-api.devsmart.co.ke/api/product/business/add/image",
          "https://api.dawasap.com/api/prescription/upload-files",
          data: formData);

      _uploadFullPrescription(presc_url, response.toString());

      //print(response);

      /*if (response.data["success"]) {
      } else {}*/

      //print("Done "+response.toString());

    } catch (e) {
      print(e);
    }
  }

  _uploadFullPrescription(String presc_url, String claim_url) async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "clientId": prefs.getString("client_id"),
      "prescription": presc_url,
      "claimform": claim_url,
      "special_instructions": _detailsController.text
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/prescription/upload", data);

    _loadingBtnController.reset();

    if (request_result["data"]["success"]) {
      /*_showSnackBar(request_result["data"]["message"].toString(), Colors.green,
          Icons.done, Colors.white, Colors.white);*/

      _showSnackBar("Prescription submitted", Colors.green, Icons.done,
          Colors.white, Colors.white);

      /*Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: HomeScreen(
                user: widget.user,
                token: widget.token,
              ),
              inheritTheme: true,
              ctx: context),
        );
      });*/
    } else {
      _showSnackBar("Something went wrong", Colors.red, Icons.error,
          Colors.white, Colors.white);
    }

    //print(request_result);
  }

  _pickPrescFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        presc_file = File(result.files.single.path.toString());
      });
      /*_uploadImage(file);*/
    } else {
      // User canceled the picker
    }
  }

  _pickClaimFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        claim_file = File(result.files.single.path.toString());
      });
      /*_uploadImage(file);*/
    } else {
      // User canceled the picker
    }
  }
}
