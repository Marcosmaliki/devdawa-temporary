import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dawasap',
      theme: ThemeData(
        /*textTheme: GoogleFonts.openSans().copyWith(

        ),*/
        //primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.green,
          secondary: AppColors.green,
        ),
      ),
      home: Splash(),
    );
  }
}
