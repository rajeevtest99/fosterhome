import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fosterhome/consts/colors.dart';

import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/models/currentUser/CurrentUserPostModel.dart';
import 'package:fosterhome/models/currentUser/currentUser.dart';
import 'package:fosterhome/utils/utils.dart';

import 'package:fosterhome/views/Screens/Profile/Followers/followers.dart';
import 'package:fosterhome/views/Screens/Profile/following/following.dart';
import 'package:page_transition/page_transition.dart';

class ProfileHelpers extends ChangeNotifier {
  Future<ProfileModel>? profileModel;
  Future<CurrentUserPostModel>? currentUserPostModel;
  final ConstantColors constantColors = ConstantColors();

  Future<UserProfileModel>? userProfileModel;

  Widget header(BuildContext context, AsyncSnapshot<ProfileModel> snapshot,
      Future<CurrentUserPostModel>? currentUserPostModel) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: constantColors.skyblue,
          backgroundImage: NetworkImage(
              snapshot.data!.data!.profilePicture == ""
                  ? "https://image.flaticon.com/icons/png/512/709/709722.png"
                  : snapshot.data!.data!.profilePicture!),
        ),
        postsCount(context, currentUserPostModel),
        boopers(context, snapshot),
        booping(context, snapshot),
      ],
    ));
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

  Widget boopers(BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: Followers(), type: PageTransitionType.rightToLeft));
      },
      child: Column(
        children: [
          Text(
            snapshot.data!.data!.boopers!.length.toString(),
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

  Widget booping(BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: Following(), type: PageTransitionType.rightToLeft));
      },
      child: Column(
        children: [
          Text(
            snapshot.data!.data!.booping!.length.toString(),
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
      BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${snapshot.data!.data!.firstname} ${snapshot.data!.data!.lastname}",
              style: TextStyle(
                  fontSize: 18,
                  color: constantColors.purple,
                  fontWeight: FontWeight.w600)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              snapshot.data!.data!.about!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget fosterStatus(
      BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
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
              snapshot.data!.data!.hasFostered!
                  ? "has fostered ${snapshot.data!.data!.fostered!} pets"
                  : "has not fostered pets",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget isWillingtofoster(
      BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
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
              snapshot.data!.data!.isWilling!
                  ? "is willing to adopt/foster a pet"
                  : "is not ready to adopt/foster a pet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget insta(BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        splashColor: snapshot.data!.data!.instaLink == ""
            ? Colors.transparent
            : Colors.grey,
        onTap: snapshot.data!.data!.instaLink == ""
            ? () {}
            : () {
                Utils.openlink(url: snapshot.data!.data!.instaLink);
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
            snapshot.data!.data!.instaId == ""
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "update your insta id",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.data!.instaId!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget facebook(BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        splashColor: snapshot.data!.data!.fbLink == ""
            ? Colors.transparent
            : Colors.grey,
        onTap: snapshot.data!.data!.fbLink == ""
            ? () {}
            : () {
                Utils.openlink(url: snapshot.data!.data!.fbLink);
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
            snapshot.data!.data!.fbId == ""
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "update your facebook id",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.data!.fbId!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget twitter(BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        splashColor: snapshot.data!.data!.twitterLink == ""
            ? Colors.transparent
            : Colors.grey,
        onTap: snapshot.data!.data!.twitterLink == ""
            ? () {}
            : () {
                Utils.openlink(url: snapshot.data!.data!.twitterLink);
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
            snapshot.data!.data!.twitterId == ""
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "update your twiiter id",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.data!.twitterId!,
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
