import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';

import 'package:fosterhome/views/login/login_helpers.dart';
import 'package:fosterhome/views/signup/about/about.dart';
import 'package:fosterhome/views/signup/signup-helpers.dart';
import 'package:fosterhome/views/signup/signup_textfields.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  //save keys

  PrefService _prefService = PrefService();
  UserIdPref _idPref = UserIdPref();

  //http call

  final Api _api = Api();
  var log = Logger();

  // validator

  final _globalKey = GlobalKey<FormState>();

  // text controllers

  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  //color instance

  final ConstantColors constantColors = ConstantColors();

  //validate username and email helpers

  String? errorUserNameText;
  String? errorEmailText;
  bool usernamevalidate = false;
  bool emailvalidate = false;
  bool circular = false;
  final spinkit = SpinKitThreeBounce(
    color: Colors.purple,
  );

  //Animation controller

  late AnimationController _fnameAnimCont;
  late Animation<Offset> _fnameAnim;
  late AnimationController _lnameAnimCont;
  late Animation<Offset> _lnameAnim;
  late AnimationController _usernameAnimCont;
  late Animation<Offset> _usernameAnim;
  late AnimationController _emailAnimCont;
  late Animation<Offset> _emailAnim;
  late AnimationController _passAnimCont;
  late Animation<Offset> _passAnim;
  late AnimationController _mainContainerCont;
  late Animation<Offset> _mainContainerAnim;
  late AnimationController _opacityCont;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    setState(() {});
    super.initState();
    _fnameAnimCont = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _fnameAnim = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(parent: _fnameAnimCont, curve: Curves.easeInOut));
    _lnameAnimCont = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _lnameAnim = Tween<Offset>(
      begin: Offset(-2.0, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(parent: _lnameAnimCont, curve: Curves.easeInOut));

    _usernameAnimCont = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _usernameAnim = Tween<Offset>(
      begin: Offset(-2.5, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(
        CurvedAnimation(parent: _usernameAnimCont, curve: Curves.easeInOut));

    _emailAnimCont = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _emailAnim = Tween<Offset>(
      begin: Offset(-3.0, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(parent: _emailAnimCont, curve: Curves.easeInOut));

    _passAnimCont = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _passAnim = Tween<Offset>(
      begin: Offset(-4.0, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(parent: _passAnimCont, curve: Curves.easeInOut));

    _opacityCont = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _opacityAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
        CurvedAnimation(parent: _opacityCont, curve: Curves.fastOutSlowIn));

    _mainContainerCont = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _mainContainerAnim = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(
        parent: _mainContainerCont, curve: Curves.easeInOutBack));

    _fnameAnimCont.forward();
    _lnameAnimCont.forward();
    _usernameAnimCont.forward();
    _passAnimCont.forward();
    _opacityCont.forward();
    _emailAnimCont.forward();
    _mainContainerCont.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _fnameAnimCont.dispose();
    _lnameAnimCont.dispose();
    _usernameAnimCont.dispose();
    _passAnimCont.dispose();
    _opacityCont.dispose();
    _emailAnimCont.dispose();
    _mainContainerCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: constantColors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Provider.of<LoginHelpers>(context, listen: false)
                  .welcomeLottie(context),
            ),
            FadeTransition(
              opacity: _opacityAnim,
              child: SlideTransition(
                position: _mainContainerAnim,
                child: Container(
                  decoration: BoxDecoration(
                      color: constantColors.white,
                      boxShadow: [
                        BoxShadow(
                            color: constantColors.lightpurple,
                            blurRadius: 3,
                            spreadRadius: 0.5,
                            offset: Offset(0.6, 0.6))
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        SlideTransition(
                          position: _fnameAnim,
                          child: Provider.of<SignUpTextFields>(context,
                                  listen: true)
                              .firstName(context, fname),
                        ),
                        SlideTransition(
                            position: _lnameAnim,
                            child: Provider.of<SignUpTextFields>(context,
                                    listen: false)
                                .lastName(context, lname)),
                        SlideTransition(
                            position: _usernameAnim,
                            child: Provider.of<SignUpTextFields>(context,
                                    listen: false)
                                .userName(
                                    context,
                                    username,
                                    usernamevalidate
                                        ? null
                                        : errorUserNameText)),
                        SlideTransition(
                          position: _emailAnim,
                          child: Provider.of<SignUpTextFields>(context,
                                  listen: false)
                              .eMail(context, email,
                                  emailvalidate ? null : errorEmailText),
                        ),
                        SlideTransition(
                          position: _passAnim,
                          child: Provider.of<SignUpTextFields>(context,
                                  listen: true)
                              .passWord(context, password),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Provider.of<SignUpHelpers>(context, listen: false)
                .alreadyuser(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            if (circular)
              spinkit
            else
              Provider.of<SignUpHelpers>(context, listen: false)
                  .signUpButton(context, () async {
                setState(() {
                  circular = true;
                });
                await checkUserName();
                await checkEmail();
                if (_globalKey.currentState!.validate() &&
                    usernamevalidate &&
                    emailvalidate) {
                  Map<String, dynamic> data = {
                    "firstname": fname.text,
                    "lastname": lname.text,
                    "username": username.text,
                    "email": email.text,
                    "password": password.text,
                  };
                  var response = await _api.post("/auth/users/signup", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Map<String, dynamic> signupoutput =
                        json.decode(response.body);
                    setState(() {
                      circular = false;
                    });
                    _prefService
                        .createCache(signupoutput["token"])
                        .whenComplete(() {
                      _idPref.saveId(signupoutput['userId']);
                      return showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: constantColors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              insetPadding: EdgeInsets.only(
                                  top: 200, bottom: 300, left: 30, right: 30),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Lottie.asset(
                                    "assets/lottie/celeb.json",
                                    frameRate: FrameRate(120),
                                    repeat: true,
                                    height: 500,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Yayy! you have successfully created an account.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: constantColors.purple,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.075,
                                      ),
                                      MaterialButton(
                                          color: constantColors.lightpurple,
                                          onPressed: () {
                                            log.i(response.body);
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                    child: About(),
                                                    type: PageTransitionType
                                                        .fade));
                                          },
                                          child: Text(
                                            "Lets get started",
                                            style: TextStyle(
                                                color: constantColors.white),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    });
                  } else {
                    setState(() {
                      circular = false;
                    });
                    return showAboutDialog(
                        context: context, children: [Text("error loging in")]);
                  }
                } else {
                  setState(() {
                    circular = false;
                  });
                }
                print("validated");
                print("tapped");
              }),
          ],
        )),
      ),
    ));
  }

  checkUserName() async {
    if (username.text.length == 0) {
      setState(() {
        usernamevalidate = false;
        errorUserNameText = "username can't be empty";
      });
    } else {
      var response = await _api.get("/user/checkusername/${username.text}");
      if (response['Status']) {
        setState(() {
          usernamevalidate = false;
          errorUserNameText = "Username already exists";
        });
      } else {
        setState(() {
          usernamevalidate = true;
        });
      }
    }
  }

  checkEmail() async {
    if (!email.text.contains("@")) {
      setState(() {
        emailvalidate = false;
        errorEmailText = "email format is not valid";
      });
    } else {
      var response = await _api.get("/user/checkemail/${email.text}");
      if (response['Status']) {
        setState(() {
          emailvalidate = false;
          errorEmailText = "Email already exists";
        });
      } else {
        setState(() {
          emailvalidate = true;
        });
      }
    }
  }
}
