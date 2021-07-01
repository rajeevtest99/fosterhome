import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fosterhome/consts/colors.dart';

import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/models/currentUser/CurrentUserPostModel.dart';

import 'package:fosterhome/utils/utils.dart';

import 'package:fosterhome/views/Screens/Profile/altProfile/followers/alt_followers.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/following/alt_following.dart';

import 'package:page_transition/page_transition.dart';

class AltProfileHelpers extends ChangeNotifier {
  Future<UserProfileModel>? userProfileModel;
  Future<CurrentUserPostModel>? currentUserPostModel;
  final ConstantColors constantColors = ConstantColors();

  Widget header(BuildContext context, AsyncSnapshot<UserProfileModel> snapshot,
      Future<CurrentUserPostModel>? currentUserPostModel) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          snapshot.data!.profilePicture == ""
              ? Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: constantColors.purple, width: 2)),
                  child: Image(image: AssetImage("assets/image/user.png")))
              : Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: constantColors.purple, width: 2)),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        NetworkImage(snapshot.data!.profilePicture!),
                  ),
                ),
          postsCount(context, currentUserPostModel),
          boopers(context, snapshot),
          booping(context, snapshot),
        ],
      )),
    );
  }

  Widget postsCount(BuildContext context,
      Future<CurrentUserPostModel>? currentUserPostModel) {
    return FutureBuilder<CurrentUserPostModel>(
        future: currentUserPostModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Text(
                  "0",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                Text(
                  "posts",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                )
              ],
            );
          }
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(
                  snapshot.data!.data!.length.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
                Text(
                  "posts",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                )
              ],
            );
          } else {
            return Text("error");
          }
        });
  }

  Widget boopers(
      BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: Altfollowers(userID: snapshot.data!.id!),
                type: PageTransitionType.rightToLeft));
      },
      child: Column(
        children: [
          Text(
            snapshot.data!.boopers!.length.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          Text(
            "boopers",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget booping(
      BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: Altfollowing(
                  userID: snapshot.data!.id,
                ),
                type: PageTransitionType.rightToLeft));
      },
      child: Column(
        children: [
          Text(
            snapshot.data!.booping!.length.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          Text(
            "booping",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget nameAndAbout(
      BuildContext context,
      AsyncSnapshot<UserProfileModel> snapshot,
      bool? follow,
      Function()? following,
      Function()? unfollow) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${snapshot.data!.firstname} ${snapshot.data!.lastname}",
                  style: TextStyle(
                      fontSize: 18,
                      color: constantColors.purple,
                      fontWeight: FontWeight.w600)),
              follow!
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: constantColors.lightpurple)),
                        child: Text(
                          "booping",
                          style: TextStyle(
                              color: constantColors.purple,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: following,
                        constraints: BoxConstraints(
                            maxHeight: 75,
                            maxWidth: 85,
                            minHeight: 35,
                            minWidth: 75),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "boop",
                          style: TextStyle(color: Colors.white),
                        ),
                        fillColor: constantColors.purple,
                        onPressed: unfollow,
                        constraints: BoxConstraints(
                            maxHeight: 75,
                            maxWidth: 85,
                            minHeight: 35,
                            minWidth: 75),
                      ),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              child: Text(
                snapshot.data!.about! == ""
                    ? "user didn't add about"
                    : snapshot.data!.about!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget fosterStatus(
      BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/fosterStatus.png',
            height: 25,
            width: 25,
            color: constantColors.purple,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              snapshot.data!.hasFostered!
                  ? "has fostered ${snapshot.data!.fostered!} pets"
                  : "has not fostered pets",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget isWillingtofoster(
      BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/willing.png',
            height: 25,
            width: 25,
            color: constantColors.purple,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              snapshot.data!.isWilling!
                  ? "is willing to adopt/foster a pet"
                  : "is not ready to adopt/foster a pet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget insta(BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: snapshot.data!.instaId == ""
          ? Container()
          : InkWell(
              splashColor: snapshot.data!.instaLink == ""
                  ? Colors.transparent
                  : Colors.grey,
              onTap: snapshot.data!.instaLink == ""
                  ? () {}
                  : () {
                      Utils.openlink(url: snapshot.data!.instaLink);
                    },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/icons/insta.png',
                      height: 22.5,
                      width: 22.5,
                      color: constantColors.purple,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.instaId!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget facebook(
      BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: snapshot.data!.fbId == ""
          ? Container()
          : InkWell(
              splashColor: snapshot.data!.fbLink == ""
                  ? Colors.transparent
                  : Colors.grey,
              onTap: snapshot.data!.fbLink == ""
                  ? () {}
                  : () {
                      Utils.openlink(url: snapshot.data!.fbLink);
                    },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/icons/fb.png',
                      height: 22.5,
                      width: 22.5,
                      color: constantColors.purple,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.fbId!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget twitter(
      BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: snapshot.data!.twitterId == ""
          ? Container()
          : InkWell(
              splashColor: snapshot.data!.twitterLink == ""
                  ? Colors.transparent
                  : Colors.grey,
              onTap: snapshot.data!.twitterLink == ""
                  ? () {}
                  : () {
                      Utils.openlink(url: snapshot.data!.twitterLink);
                    },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/icons/twitter.png',
                      height: 22.5,
                      width: 22.5,
                      color: constantColors.purple,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.twitterId!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
