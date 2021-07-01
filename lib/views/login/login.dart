import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fosterhome/consts/colors.dart';

import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/usernamePrefs.dart';
import 'package:fosterhome/views/HomePage/homepage.dart';
import 'package:fosterhome/views/login/login_helpers.dart';

import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  //http call

  final Api _api = Api();
  var log = Logger();

  //shareprefs write call

  PrefService _prefService = PrefService();
  UserIdPref _idPref = UserIdPref();
  UserNamePref _userNamePref = UserNamePref();
  String? userId;

  //email and pass err helpers

  bool validate = false;
  bool circular = false;
  final spinkit = SpinKitThreeBounce(
    color: Color(0xff7868e6),
  );

  //error text

  String? errorPassText;
  String? errorEmailText;

  //text conts

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  //Animation conts

  final ConstantColors constantColors = ConstantColors();
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
    super.initState();

    _emailAnimCont = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _emailAnim = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(parent: _emailAnimCont, curve: Curves.easeInOut));

    _passAnimCont = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _passAnim = Tween<Offset>(
      begin: Offset(3.0, 0.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(parent: _passAnimCont, curve: Curves.easeInOut));

    _opacityCont = AnimationController(
        duration: Duration(milliseconds: 4000), vsync: this);
    _opacityAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
        CurvedAnimation(parent: _opacityCont, curve: Curves.fastOutSlowIn));

    _mainContainerCont = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _mainContainerAnim = Tween<Offset>(
      begin: Offset(0.0, -4.0),
      end: Offset(
        0.0,
        0.0,
      ),
    ).animate(CurvedAnimation(
        parent: _mainContainerCont, curve: Curves.easeInOutBack));

    _passAnimCont.forward();
    _opacityCont.forward();
    _emailAnimCont.forward();
    _mainContainerCont.forward();
  }

  @override
  void dispose() {
    _passAnimCont.dispose();
    _opacityCont.dispose();
    _emailAnimCont.dispose();
    _mainContainerCont.dispose();
    super.dispose();
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
              height: MediaQuery.of(context).size.height * 0.35,
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
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _emailAnim,
                        child: Provider.of<LoginHelpers>(context, listen: false)
                            .eMail(context, email),
                      ),
                      SlideTransition(
                        position: _passAnim,
                        child: Provider.of<LoginHelpers>(context, listen: false)
                            .passWord(context, password,
                                validate ? null : errorPassText),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Provider.of<LoginHelpers>(context, listen: false)
                .alreadyuser(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            circular
                ? spinkit
                : Provider.of<LoginHelpers>(context, listen: false)
                    .loginButton(context, () async {
                    setState(() {
                      circular = true;
                    });

                    Map<String, dynamic> logindata = {
                      "email": email.text,
                      "password": password.text
                    };
                    var response =
                        await _api.post("auth/users/login", logindata);

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> loginoutput =
                          json.decode(response.body);
                      setState(() {
                        circular = false;
                        validate = true;
                      });

                      _prefService
                          .createCache(loginoutput["token"])
                          .whenComplete(() {
                        _idPref.saveId(loginoutput['userId']);
                        _userNamePref.saveUserName(loginoutput['username']);
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.bottomToTop),
                            (route) => false);
                      });

                      print(loginoutput['token']);
                      print(loginoutput['userId']);
                      log.i(response.body);
                      log.i(response.statusCode);
                    } else {
                      String? loginres = json.decode(response.body);
                      setState(() {
                        circular = false;
                        validate = false;
                        errorPassText = loginres;
                      });
                    }
                  }),
          ],
        )),
      ),
    ));
  }
}
