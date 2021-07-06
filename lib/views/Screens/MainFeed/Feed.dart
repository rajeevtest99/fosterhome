import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:fosterhome/Widgets/Postcard.dart';
import 'package:fosterhome/Widgets/shimmerTile.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/FeedAndDetailPostModel/SinglePostModel.dart';

import 'package:fosterhome/models/FeedAndDetailPostModel/postDetailModel.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';
import 'package:fosterhome/services/api.dart';

import 'package:fosterhome/services/post_FeedServices/FeedService.dart';

import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/views/Screens/MainFeed/AddPost/addPost.dart';
import 'package:fosterhome/views/Screens/MainFeed/UpdatePost/UpdatePost.dart';
import 'package:fosterhome/views/Screens/MainFeed/singlePost/singlePost.dart';

import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import 'package:timeago/timeago.dart' as timeago;

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  //const colors

  final ConstantColors constantColors = ConstantColors();

  //reading secured keys for userId from SharedPrefs

  UserIdPref _idPref = UserIdPref();

  //api call

  Api _api = Api();
  String? userID = '';
  String likes = '';

  //Api models

  Future<DetailPost?>? _detailPost;
  Future<SinglePost>? singlePost;
  Future<UserProfileModel?>? userProfileModel;

  //animation

  bool? isLiked;

  @override
  void initState() {
    super.initState();
    _detailPost = FeedServices().getFeed();

    _checkUserID();
  }

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          color: constantColors.lightpurple,
          onRefresh: () async {
            setState(() {
              _detailPost = FeedServices().getFeed();
            });
          },
          child: FutureBuilder<DetailPost?>(
            future: _detailPost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.feed!.length > 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset(
                                "assets/icons/rss.png",
                                color: Colors.black,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "your feed",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.feed!.length,
                            itemBuilder: (context, index) {
                              var posts = snapshot.data!.feed![index];

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
                                  child: Column(
                                    children: [
                                      FutureBuilder<UserProfileModel?>(
                                          future: userProfileModel =
                                              UserProfileServices()
                                                  .getUserProfile(
                                                      posts.userId!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var contain = posts.likes!.where(
                                                  (element) =>
                                                      element == userID);
                                              if (contain.isEmpty) {
                                                isLiked = false;
                                              } else {
                                                isLiked = true;
                                              }

                                              return PostCard(
                                                  firstname:
                                                      snapshot.data!.firstname!,
                                                  lastname:
                                                      snapshot.data!.lastname!,
                                                  like: isLiked,
                                                  profileP: snapshot.data!
                                                              .profilePicture! ==
                                                          ""
                                                      ? "https://source.unsplash.com/random"
                                                      : snapshot
                                                          .data!.profilePicture,
                                                  time: timeago.format(posts
                                                      .createdAt!
                                                      .toLocal()),
                                                  description:
                                                      posts.description,
                                                  comment: () {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                        builder: (context) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child: Container(
                                                                margin: EdgeInsets.only(
                                                                    top: MediaQuery.of(
                                                                            context)
                                                                        .viewPadding
                                                                        .top),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.65,
                                                                child: SinglePostScreen(
                                                                    postID: posts
                                                                        .id)),
                                                          );
                                                        });
                                                    print('comment');
                                                  },
                                                  share: () {
                                                    print('share');
                                                  },
                                                  options: posts.userId ==
                                                          userID
                                                      ? PopupMenuButton<int>(
                                                          onSelected: (item) =>
                                                              selected(
                                                                  context,
                                                                  item,
                                                                  posts.id!),
                                                          itemBuilder:
                                                              (context) => [
                                                                    PopupMenuItem(
                                                                        value:
                                                                            0,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.edit),
                                                                            Text("edit")
                                                                          ],
                                                                        )),
                                                                    PopupMenuItem(
                                                                        value:
                                                                            1,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.delete),
                                                                            Text("delete")
                                                                          ],
                                                                        )),
                                                                  ])
                                                      : Container(),
                                                  tap: () async {
                                                    Map<String, dynamic>
                                                        likefunction = {
                                                      "userId": userID,
                                                    };
                                                    var response = await _api.put(
                                                        "posts/like/${posts.id}",
                                                        likefunction);
                                                    if (response.statusCode ==
                                                            200 ||
                                                        response.statusCode ==
                                                            201) {
                                                      String? likeoutput =
                                                          json.decode(
                                                              response.body);
                                                      setState(() {
                                                        _detailPost =
                                                            FeedServices()
                                                                .getFeed();
                                                      });

                                                      print(likeoutput);
                                                    }
                                                  },
                                                  commentno: posts
                                                      .comments!.length
                                                      .toString(),
                                                  likeno: posts.likes!.length
                                                      .toString(),
                                                  image: posts.image! == ""
                                                      ? Container()
                                                      : Container(
                                                          child: Image.network(
                                                              posts.image!),
                                                        ));
                                            } else {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: ShimmerWidget
                                                          .circular(
                                                              width: 50,
                                                              height: 50),
                                                      title: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: ShimmerWidget
                                                            .rectangular(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                height: 10),
                                                      ),
                                                      subtitle: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: ShimmerWidget
                                                            .rectangular(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3,
                                                                height: 10),
                                                      ),
                                                    ),
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.275,
                                                      child: Center(
                                                          child: Lottie.asset(
                                                              "assets/lottie/loading.json",
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.075,
                                                              frameRate:
                                                                  FrameRate(
                                                                      60))),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                } else {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/emptyfeed.png",
                        height: MediaQuery.of(context).size.height * 0.15,
                        color: constantColors.lightpurple,
                      ),
                      Text(
                        "your feed is empty,",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "start following people",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ));
                }
              } else {
                return Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: MediaQuery.of(context).size.height * 0.1,
                        frameRate: FrameRate(60)));
              }
            },
          ),
        ),
        floatingActionButton: OpenContainer(
          closedColor: constantColors.white,
          closedShape: CircleBorder(),
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: Duration(milliseconds: 300),
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return MaterialButton(
              height: MediaQuery.of(context).size.height * 0.075,
              color: constantColors.white,
              shape: CircleBorder(),
              child: Icon(
                Icons.add,
                color: constantColors.purple,
              ),
              onPressed: openContainer,
            );
          },
          openBuilder: (BuildContext _, VoidCallback __) {
            return AddPost();
          },
        ),
      ),
    );
  }

  void selected(BuildContext context, int item, String postId) {
    switch (item) {
      case 0:
        Navigator.push(
            context,
            PageTransition(
                child: UpdatePost(
                  postId: postId,
                ),
                type: PageTransitionType.fade));
        break;
      case 1:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "are you sure you want to delete the post?",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                actions: [
                  MaterialButton(
                      color: constantColors.purple,
                      onPressed: () async {
                        Map<String, dynamic> deleteinput = {
                          "id": postId,
                          "userId": "$userID"
                        };
                        var response = await _api.delete(
                            "posts/$postId/delete", deleteinput);
                        if (response == 200 || response == 201) {
                          String output = json.decode((response));
                          print(response);
                          print(output);
                        }
                        Navigator.pop(context);
                        setState(() {
                          _detailPost = FeedServices().getFeed();
                        });
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      )),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("no",
                        style: TextStyle(color: constantColors.purple)),
                  )
                ],
              );
            });
    }
  }
}
