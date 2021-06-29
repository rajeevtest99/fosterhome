import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fosterhome/Widgets/Postcard.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/models/currentUser/CurrentUserPostModel.dart';
import 'package:fosterhome/models/currentUser/currentUser.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/currentuser/CurrentUserPostServices.dart';
import 'package:fosterhome/services/currentuser/currentuserServices.dart';

import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';

import 'package:fosterhome/views/Screens/Profile/profilehelpers.dart';
import 'package:fosterhome/views/Screens/Profile/updateProfile/updateProfile.dart';
import 'package:fosterhome/views/login/login.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Profile extends StatefulWidget {
  final String? userName;
  Profile({@required this.userName});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  PrefService _prefService = PrefService();
  UserIdPref _idPref = UserIdPref();
  final ConstantColors constantColors = ConstantColors();

  final Api _api = Api();

  Future<ProfileModel>? profileModel;
  Future<CurrentUserPostModel>? currentUserPostModel;
  Future<UserProfileModel>? userProfileModel;

  String? userID = '';

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    //checkUserData();
    profileModel = CurrentUserServices().getCurrentUserProfile();
    currentUserPostModel = CurrentUserPostServices().getCurrentUserPost();

    _checkUserID();
  }

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
    print(userID);
  }

  checkUserData() async {
    var response = await _api.get("/user/getuser/${widget.userName}");
    if (response == 200 || response == 201) {
      Map<String, dynamic>? data = json.decode(response);
      print(data);
      print(widget.userName);
    }
  }

  logout() async {
    String? id = await (_idPref.readId(USER_ID_KEY));
    print(id);
    _prefService.removeCache("myfosterpass").whenComplete(() =>
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: Login(), type: PageTransitionType.bottomToTop),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
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
          title: FutureBuilder<ProfileModel>(
            future: profileModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.data!.username!,
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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: UpdateProfile(),
                          type: PageTransitionType.leftToRight));
                },
                icon: Icon(Icons.more_horiz, color: Colors.black))
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  child: Container(
                      child: Column(children: [
                    FutureBuilder<ProfileModel>(
                      future: profileModel,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            margin: EdgeInsets.all(4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Provider.of<ProfileHelpers>(context,
                                        listen: true)
                                    .header(context, snapshot,
                                        currentUserPostModel),
                                Provider.of<ProfileHelpers>(context,
                                        listen: false)
                                    .nameAndAbout(context, snapshot),
                                Provider.of<ProfileHelpers>(context,
                                        listen: false)
                                    .fosterStatus(context, snapshot),
                                Provider.of<ProfileHelpers>(context,
                                        listen: false)
                                    .isWillingtofoster(context, snapshot),
                                Divider(
                                  thickness: 0.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Social",
                                      style: TextStyle(fontSize: 22)),
                                ),
                                Provider.of<ProfileHelpers>(context,
                                        listen: false)
                                    .insta(context, snapshot),
                                Provider.of<ProfileHelpers>(context,
                                        listen: false)
                                    .facebook(context, snapshot),
                                Provider.of<ProfileHelpers>(context,
                                        listen: false)
                                    .twitter(context, snapshot),
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
                  ])),
                  preferredSize: MediaQuery.of(context).size * 0.45,
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
                                              CurrentUserPostServices()
                                                  .getCurrentUserPost();
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
