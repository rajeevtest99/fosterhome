import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosterhome/Widgets/shimmerTile.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';

class Altfollowing extends StatefulWidget {
  const Altfollowing({Key? key, @required this.userID}) : super(key: key);
  final String? userID;

  @override
  _AltfollowingState createState() => _AltfollowingState();
}

class _AltfollowingState extends State<Altfollowing> {
  //consts Colors

  final ConstantColors constantColors = ConstantColors();

  //Api Call

  final Api _api = Api();

  //Api models

  Future<UserProfileModel>? otherusers;
  Future<UserProfileModel>? following;

  //reading secured keys for userId from SharedPrefs

  UserIdPref _idPref = UserIdPref();

  //elements  required for Api Call

  String? userID = '';
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _checkUserID();
    otherusers = UserProfileServices().getUserProfile(widget.userID);
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
      body: FutureBuilder<UserProfileModel>(
        future: otherusers,
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
          if (snapshot.data!.booping!.length == 0) {
            return Center(
                child: Text(
              "user is not booping anyone",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ));
          }
          return ListView.builder(
              itemCount: snapshot.data!.booping!.length,
              itemBuilder: (context, index) {
                var users = snapshot.data!.booping![index];
                return FutureBuilder<UserProfileModel>(
                    future: following =
                        UserProfileServices().getUserProfile(users),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var contain = snapshot.data!.boopers!
                            .where((element) => element == userID);
                        if (contain.isEmpty) {
                          isFollowing = false;
                        } else {
                          isFollowing = true;
                        }
                        return ListTile(
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
                            trailing: snapshot.data!.id! == userID
                                ? Text("")
                                : isFollowing
                                    ? followinguser(snapshot.data!.id!)
                                    : follow(snapshot.data!.id!));
                      } else {
                        return Container();
                      }
                    });
              });
        },
      ),
    );
  }

  Widget followinguser(String followerId) {
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
            otherusers = UserProfileServices().getUserProfile(widget.userID);
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
        Map<String, String> unfollow = {"userId": userID!};
        var response = await _api.put("user/$followingId/follow", unfollow);
        if (response.statusCode == 200 || response.statusCode == 201) {
          String unfollowoutput = json.decode(response.body);
          print(unfollowoutput);
          print(response.body);
          setState(() {
            otherusers = UserProfileServices().getUserProfile(widget.userID);
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
