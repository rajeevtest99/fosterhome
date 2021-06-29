import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosterhome/Widgets/Postcard.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/models/currentUser/CurrentUserPostModel.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/post_FeedServices/getUserPostsServices.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile_helpers.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class AltProfile extends StatefulWidget {
  AltProfile(
      {Key? key,
      @required this.userId,
      @required this.size,
      @required this.textlength})
      : super(key: key);
  final String? userId;
  final bool? size;
  final double? textlength;

  @override
  _AltProfileState createState() => _AltProfileState();
}

class _AltProfileState extends State<AltProfile> {
  final ConstantColors constantColors = ConstantColors();
  Future<UserProfileModel>? userProfileModel;
  Future<CurrentUserPostModel>? currentUserPostModel;
  UserIdPref _idPref = UserIdPref();
  bool isLiked = false;
  String? userID = '';
  final Api _api = Api();
  bool isFollowing = false;
  bool oneLine = false;

  @override
  void initState() {
    super.initState();
    currentUserPostModel = GetUserPostServices().getUserPost(widget.userId);
    userProfileModel = UserProfileServices().getUserProfile(widget.userId);
    _checkUserID();
  }

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.75,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: constantColors.lightpurple,
              )),
          title: FutureBuilder<UserProfileModel>(
            future: userProfileModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.username!,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: FutureBuilder<UserProfileModel>(
                        future: userProfileModel,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData) {
                            var contain = snapshot.data!.boopers!
                                .where((element) => element == userID);
                            if (contain.isEmpty) {
                              isFollowing = false;
                            } else {
                              isFollowing = true;
                            }
                            print(snapshot.data!.about!.length.toString());
                            return Container(
                              margin: EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .header(context, snapshot,
                                          currentUserPostModel),
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .nameAndAbout(
                                    context,
                                    snapshot,
                                    isFollowing,
                                    () async {
                                      Map<String, String> unfollow = {
                                        "userId": userID!
                                      };
                                      var response = await _api.put(
                                          "user/${snapshot.data!.id}/unfollow",
                                          unfollow);
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 201) {
                                        String unfollowoutput =
                                            json.decode(response.body);
                                        print(unfollowoutput);
                                        print(response.body);
                                        setState(() {
                                          userProfileModel =
                                              UserProfileServices()
                                                  .getUserProfile(
                                                      widget.userId);
                                        });
                                      }
                                    },
                                    () async {
                                      Map<String, String> follow = {
                                        "userId": userID!
                                      };
                                      var response = await _api.put(
                                          "user/${snapshot.data!.id}/follow",
                                          follow);
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 201) {
                                        String unfollowoutput =
                                            json.decode(response.body);
                                        print(unfollowoutput);
                                        print(response.body);
                                        setState(() {
                                          userProfileModel =
                                              UserProfileServices()
                                                  .getUserProfile(
                                                      widget.userId);
                                        });
                                      }
                                    },
                                  ),
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .fosterStatus(context, snapshot),
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .isWillingtofoster(context, snapshot),
                                  Divider(
                                    thickness: 0.5,
                                  ),
                                  snapshot.data!.hideSocial!
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Social",
                                              style: TextStyle(fontSize: 22)),
                                        ),
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .insta(context, snapshot),
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .facebook(context, snapshot),
                                  Provider.of<AltProfileHelpers>(context,
                                          listen: false)
                                      .twitter(context, snapshot),
                                  Container(),
                                  Container(),
                                  Container()
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  preferredSize: screenheight > 770
                      ? widget.textlength! <= 60
                          ? widget.size!
                              ? MediaQuery.of(context).size * 0.38
                              : MediaQuery.of(context).size * 0.6
                          : widget.textlength! <= 140
                              ? widget.size!
                                  ? MediaQuery.of(context).size * 0.475
                                  : MediaQuery.of(context).size * 0.635
                              : widget.size!
                                  ? MediaQuery.of(context).size * 0.575
                                  : MediaQuery.of(context).size * 0.665
                      :
                      //else screensize lesser than 760
                      widget.textlength! <= 60
                          ? widget.size!
                              ? MediaQuery.of(context).size * 0.38
                              : MediaQuery.of(context).size * 0.565
                          : widget.textlength! <= 140
                              ? widget.size!
                                  ? MediaQuery.of(context).size * 0.435
                                  : MediaQuery.of(context).size * 0.635
                              : widget.size!
                                  ? MediaQuery.of(context).size * 0.475
                                  : MediaQuery.of(context).size * 0.665,
                  // preferredSize: widget.size!
                  //     ? widget.textlength! <= 60
                  //         ? MediaQuery.of(context).size * 0.375
                  //         : widget.textlength! <= 140
                  //             ? MediaQuery.of(context).size * 0.425
                  //             : MediaQuery.of(context).size * 0.475
                  //     : widget.textlength! <= 60
                  //         ? MediaQuery.of(context).size * 0.525
                  //         : widget.textlength! <= 140
                  //             ? MediaQuery.of(context).size * 0.575
                  //             : MediaQuery.of(context).size * 0.6,
                ),
              )
            ];
          },
          body: FutureBuilder<CurrentUserPostModel?>(
            future: currentUserPostModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      var posts = snapshot.data!.data![index];

                      print(snapshot.data!.data!.length.toString());
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: constantColors.lightpurple,
                                    blurRadius: 1,
                                    spreadRadius: 0.1,
                                    offset: Offset(0.0, 0.6))
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: FutureBuilder<UserProfileModel>(
                            future: userProfileModel = UserProfileServices()
                                .getUserProfile(posts.userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var contain = posts.likes!
                                    .where((element) => element == userID);
                                if (contain.isEmpty) {
                                  isLiked = false;
                                } else {
                                  isLiked = true;
                                }
                                return PostCard(
                                    firstname: snapshot.data!.firstname!,
                                    lastname: snapshot.data!.lastname!,
                                    like: isLiked,
                                    profileP: snapshot.data!.profilePicture! ==
                                            ""
                                        ? "https://source.unsplash.com/random"
                                        : snapshot.data!.profilePicture,
                                    time: timeago
                                        .format(posts.createdAt!.toLocal()),
                                    description: posts.description,
                                    comment: () {
                                      print('comment');
                                    },
                                    share: () {
                                      print('share');
                                    },
                                    options: posts.userId == userID
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.more_horiz),
                                          )
                                        : Container(),
                                    tap: () async {
                                      Map<String, dynamic> likefunction = {
                                        "userId": userID,
                                      };
                                      var response = await _api.put(
                                          "posts/like/${posts.id}",
                                          likefunction);
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 201) {
                                        String? likeoutput =
                                            json.decode(response.body);
                                        setState(() {
                                          currentUserPostModel =
                                              GetUserPostServices()
                                                  .getUserPost(widget.userId);
                                        });

                                        print(likeoutput);
                                      }
                                    },
                                    commentno:
                                        posts.comments!.length.toString(),
                                    likeno: posts.likes!.length.toString(),
                                    image: posts.image! == ""
                                        ? Container()
                                        : Container(
                                            child: Image.network(posts.image!),
                                          ));
                              } else {
                                return Center(
                                    child: Lottie.asset(
                                        "assets/lottie/loading.json",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.075,
                                        frameRate: FrameRate(60)));
                              }
                            },
                          ),
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
