import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/views/HomePage/homepage.dart';
import 'package:fosterhome/views/signup/about/about_helpers.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  //consts Colors

  final ConstantColors constantColors = ConstantColors();

  //bool for hiding social media

  bool? hideSocialMedia = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    child: Text(
                      "skip",
                      style: TextStyle(
                          color: constantColors.lightpurple,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: HomePage(),
                              type: PageTransitionType.leftToRight));
                    })
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Provider.of<AboutHelpers>(context, listen: true)
                  .addPhoto(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Provider.of<AboutHelpers>(context, listen: false)
                    .aboutField(context),
              ),
              Provider.of<AboutHelpers>(context, listen: false)
                  .fosterdetails(context),
              Provider.of<AboutHelpers>(context, listen: false)
                  .isWillingto(context),
              Provider.of<AboutHelpers>(context, listen: false).insta(context),
              Provider.of<AboutHelpers>(context, listen: false)
                  .facebook(context),
              Provider.of<AboutHelpers>(context, listen: false)
                  .twitter(context),
              Provider.of<AboutHelpers>(context, listen: false)
                  .hideSocial(context),
              Provider.of<AboutHelpers>(context, listen: true).nothing(context),
            ],
          ),
        ),
      ),
    );
  }
}
