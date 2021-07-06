import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageHelpers extends ChangeNotifier {
  //const Colors

  final ConstantColors constantColors = ConstantColors();

  //text Controller

  final TextEditingController searchText = TextEditingController();

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RichText(
            text: TextSpan(
                text: 'Foster',
                style: GoogleFonts.fredokaOne(
                    fontSize: 24, color: constantColors.lightpurple),
                children: [
              TextSpan(
                  text: 'Home',
                  style: GoogleFonts.fredokaOne(
                      fontSize: 28, color: constantColors.purple))
            ])),
      ),
      bottom: PreferredSize(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              cursorHeight: 15,
              cursorColor: constantColors.purple,
              cursorWidth: 1,
              controller: searchText,
              textAlign: TextAlign.left,
              style: TextStyle(color: constantColors.lightpurple),
              decoration: InputDecoration(
                  hintText: "Search users, nearby,...",
                  contentPadding: EdgeInsets.all(1.0),
                  hintStyle:
                      TextStyle(color: constantColors.purple, height: 1.4),
                  fillColor: constantColors.skyblue,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                        height: 5,
                        width: 5,
                        child: SvgPicture.asset(
                          "assets/icons/search.svg",
                          height: 1.5,
                          width: 1.5,
                          color: constantColors.lightpurple,
                        )),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: constantColors.lightpurple,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: constantColors.purple,
                      ))),
            ),
          ),
          preferredSize: MediaQuery.of(context).size * 0.075),
    );
  }
}
