import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fosterhome/views/HomePage/HomePagehelpers.dart';

import 'package:fosterhome/views/Screens/MainFeed/singlePost/singlePostHelpers.dart';

import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile_helpers.dart';
import 'package:fosterhome/views/Screens/Profile/profilehelpers.dart';
import 'package:fosterhome/views/Screens/Profile/updateProfile/updateProfile_helpers.dart';
import 'package:fosterhome/views/SplashScreen/splash.dart';
import 'package:fosterhome/views/login/login_helpers.dart';

import 'package:fosterhome/views/signup/about/about_helpers.dart';
import 'package:fosterhome/views/signup/signup-helpers.dart';
import 'package:fosterhome/views/signup/signup_textfields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.quicksandTextTheme()),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => LoginHelpers()),
        ChangeNotifierProvider(create: (_) => SignUpHelpers()),
        ChangeNotifierProvider(create: (_) => SignUpTextFields()),
        ChangeNotifierProvider(create: (_) => AboutHelpers()),
        ChangeNotifierProvider(create: (_) => HomePageHelpers()),
        ChangeNotifierProvider(
          create: (_) => SinglePageHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => AltProfileHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => UpdateProfileHelpers(),
        ),
      ],
    );
  }
}
