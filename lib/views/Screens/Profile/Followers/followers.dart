import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosterhome/Widgets/shimmerTile.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';

import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/models/currentUser/CurrentUserPostModel.dart';
import 'package:fosterhome/models/currentUser/currentUser.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';
import 'package:fosterhome/services/api.dart';

import 'package:fosterhome/services/currentuser/currentuserServices.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile.dart';
import 'package:page_transition/page_transition.dart';

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  final ConstantColors constantColors = ConstantColors();
  final Api _api = Api();
  Future<CurrentUserPostModel>? currentUserPostModel;
  Future<ProfileModel>? profileModel;
  Future<UserProfileModel>? otheruser;
  UserIdPref _idPref = UserIdPref();
  String? userID = '';
  bool isFollowing = false;
  var users = '';

  @override
  void initState() {
    super.initState();

    _checkUserID();
    profileModel = CurrentUserServices().getCurrentUserProfile();
  }

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.75,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: constantColors.purple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        // child:
        //  Provider.of<FollowerHelpers>(context, listen: true)
        //     .main(context, userProfileModel, isFollowing, userID!),
        child: FutureBuilder<ProfileModel>(
          future: profileModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ShimmerWidget.circular(width: 50, height: 50),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: ShimmerWidget.rectangular(
                            width: MediaQuery.of(context).size.width * 0.275,
                            height: 10),
                      ),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: ShimmerWidget.rectangular(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 10),
                      ),
                    );
                  });
            }
            if (snapshot.data!.data!.boopers!.length == 0) {
              return Center(
                  child: Text(
                "no boopers",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.data!.boopers!.length,
                  itemBuilder: (context, index) {
                    var users = snapshot.data!.data!.boopers![index];

                    return FutureBuilder<UserProfileModel>(
                      future: otheruser =
                          UserProfileServices().getUserProfile(users),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            leading:
                                ShimmerWidget.circular(width: 50, height: 50),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: ShimmerWidget.rectangular(
                                  width:
                                      MediaQuery.of(context).size.width * 0.275,
                                  height: 10),
                            ),
                            subtitle: Align(
                              alignment: Alignment.centerLeft,
                              child: ShimmerWidget.rectangular(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 10),
                            ),
                          );
                        }

                        var contain = snapshot.data!.boopers!
                            .where((element) => element == userID);
                        if (contain.isEmpty) {
                          isFollowing = false;
                        } else {
                          isFollowing = true;
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userId: snapshot.data!.id,
                                      size: snapshot.data!.hideSocial,
                                      textlength: snapshot.data!.about!.length
                                          .toDouble(),
                                    ),
                                    type: PageTransitionType.fade));
                          },
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data!.profilePicture == ""
                                      ? "https://source.unsplash.com/random"
                                      : snapshot.data!.profilePicture!,
                                ),
                              ),
                              title: Text(
                                snapshot.data!.username!,
                                style: TextStyle(
                                    color: constantColors.purple,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                "${snapshot.data!.firstname!} ${snapshot.data!.lastname!}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              trailing: isFollowing
                                  ? following(snapshot.data!.id!)
                                  : follow(snapshot.data!.id!)),
                        );
                      },
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget following(String followerId) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: constantColors.lightpurple)),
      onPressed: () async {
        Map<String, String> unfollow = {"userId": userID!};
        var response = await _api.put("user/$followerId/unfollow", unfollow);
        if (response.statusCode == 200 || response.statusCode == 201) {
          String unfollowoutput = json.decode(response.body);
          print(unfollowoutput);
          print(response.body);
          setState(() {
            profileModel = CurrentUserServices().getCurrentUserProfile();
          });
        }
      },
      constraints: BoxConstraints(
          maxHeight: 75, maxWidth: 85, minHeight: 35, minWidth: 75),
      child: Text(
        "booping",
        style: TextStyle(color: constantColors.purple),
      ),
    );
  }

  Widget follow(String followingId) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: constantColors.purple,
      onPressed: () async {
        Map<String, String> follow = {"userId": userID!};
        var response = await _api.put("user/$followingId/follow", follow);
        if (response.statusCode == 200 || response.statusCode == 201) {
          String unfollowoutput = json.decode(response.body);
          print(unfollowoutput);
          print(response.body);
          setState(() {
            profileModel = CurrentUserServices().getCurrentUserProfile();
          });
        }
      },
      constraints: BoxConstraints(
          maxHeight: 75, maxWidth: 85, minHeight: 35, minWidth: 75),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "boop",
            style: TextStyle(color: constantColors.white),
          ),
          Icon(
            Icons.add,
            size: 12,
            color: constantColors.white,
          )
        ],
      ),
    );
  }
}
