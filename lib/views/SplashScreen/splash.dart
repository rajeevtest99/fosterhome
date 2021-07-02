import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/views/HomePage/homepage.dart';

import 'package:fosterhome/views/signup/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ConstantColors constantColors = ConstantColors();
  PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readCache(TOKEN_KEY).then((value) {
      if (value != null) {
        return Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.fade)));
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                PageTransition(
                    child: SignUp(), type: PageTransitionType.fade)));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: RichText(
              text: TextSpan(
                  text: 'Foster',
                  style: GoogleFonts.fredokaOne(
                      fontSize: 32, color: constantColors.lightpurple),
                  children: [
            TextSpan(
                text: 'Home',
                style: GoogleFonts.fredokaOne(
                    fontSize: 36, color: constantColors.purple))
          ]))),
    );
  }
}
