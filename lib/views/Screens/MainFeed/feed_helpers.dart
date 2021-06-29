import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fosterhome/consts/colors.dart';

import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';

import 'package:google_fonts/google_fonts.dart';

class FeedHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController searchText = TextEditingController();
  Future<UserProfileModel>? userProfileModel;

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
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8, bottom: 12),
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
          ),
          preferredSize: MediaQuery.of(context).size * 0.075),
    );
  }

  Widget postCard(BuildContext context, String description) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        description,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget postHeader(BuildContext context, String profileP, String name,
      String time, Widget icon, void Function()? tap) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(profileP),
            radius: 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      color: constantColors.purple,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.035,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        time,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            onTap: tap,
            child: icon,
          ),
        )
      ],
    );
  }

  Widget buttonBar(BuildContext context, AnimatedBuilder animation,
      String likeno, Function comment, String commentno, Function share) {
    return Container(
      /*decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 0.25, color: Colors.grey),
      )),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            /*decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 0.5, color: Colors.grey))),*/
            width: MediaQuery.of(context).size.width * 0.315,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                animation,
                Text(likeno),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: SvgPicture.asset(
                        "assets/icons/comment.svg",
                        color: constantColors.purple,
                      ),
                    ),
                    onPressed: comment as void Function()?),
                Text(
                  commentno,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.315,
            /*decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(width: 0.5, color: Colors.grey))),*/
            child: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.all(7.5),
                  child: SvgPicture.asset("assets/icons/share.svg",
                      color: constantColors.lightpurple),
                ),
                onPressed: share as void Function()?),
          ),
        ],
      ),
    );
  }
}
