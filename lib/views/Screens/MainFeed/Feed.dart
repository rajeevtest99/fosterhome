import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  //const colors
  final ConstantColors constantColors = ConstantColors();
  UserIdPref _idPref = UserIdPref();
  String? userID = '';
  String likes = '';

  //api call

  Api _api = Api();

  //posts services
  Future<DetailPost?>? _detailPost;
  bool? loading;
  Future<SinglePost>? singlePost;

  String? userPhoto;

  Future<UserProfileModel?>? userProfileModel;

  //animation
  bool? isLiked;
  late AnimationController _iconCont;
  late Animation<double> _iconAnim;

  @override
  void initState() {
    super.initState();
    _detailPost = FeedServices().getFeed();
    _iconCont = AnimationController(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        vsync: this);
    _iconAnim = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 20, end: 26), weight: 26),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 26, end: 20), weight: 20)
    ]).animate(_iconCont);

    _iconCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isLiked = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isLiked = false;
        });
      }
    });

    _checkUserID();
  }

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<DetailPost?>(
          future: _detailPost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            "assets/icons/rss.png",
                            color: Colors.black,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

                          print(snapshot.data!.feed!.length.toString());
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
                                              .getUserProfile(posts.userId!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var contain = posts.likes!.where(
                                              (element) => element == userID);
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
                                              time: timeago.format(
                                                  posts.createdAt!.toLocal()),
                                              description: posts.description,
                                              comment: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
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
                                                            child:
                                                                SinglePostScreen(
                                                                    postID: posts
                                                                        .id)),
                                                      );
                                                    });
                                                print('comment');
                                              },
                                              share: () {
                                                print('share');
                                              },
                                              options: posts.userId == userID
                                                  ? IconButton(
                                                      icon:
                                                          Icon(Icons.more_vert),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: UpdatePost(
                                                                    postId: posts
                                                                        .id),
                                                                type: PageTransitionType
                                                                    .bottomToTop));
                                                      },
                                                    )
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
                                                  String? likeoutput = json
                                                      .decode(response.body);
                                                  setState(() {
                                                    _detailPost = FeedServices()
                                                        .getFeed();
                                                  });

                                                  print(likeoutput);
                                                }
                                              },
                                              commentno: posts.comments!.length
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
                                                  leading:
                                                      ShimmerWidget.circular(
                                                          width: 50,
                                                          height: 50),
                                                  title: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
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
                                                    alignment:
                                                        Alignment.centerLeft,
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
                                                  height: MediaQuery.of(context)
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
                                                              FrameRate(60))),
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
                  child: Lottie.asset("assets/lottie/loading.json",
                      height: MediaQuery.of(context).size.height * 0.1,
                      frameRate: FrameRate(60)));
            }
          },
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

  Widget postCard(
    BuildContext context,
    String? firstname,
    String? lastname,
    String? profileP,
    String? time,
    String? description,
    String? commentno,
    String? likeno,
    Container? image,
    void Function()? comment,
    void Function()? like,
    void Function()? share,
  ) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileP!),
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
                      "${firstname!} ${lastname!}",
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
                            time!,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            description!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
        image!,
        Container(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedBuilder(
                          animation: _iconAnim,
                          builder: (BuildContext context, _) {
                            return IconButton(
                                iconSize: _iconAnim.value,
                                icon: SvgPicture.asset(
                                  isLiked!
                                      ? "assets/icons/liked.svg"
                                      : "assets/icons/unlike.svg",
                                  height: _iconAnim.value,
                                  width: _iconAnim.value,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLiked!
                                        ? _iconCont.reverse()
                                        : _iconCont.forward();
                                  });
                                });
                          }),
                    ),
                    Text(likeno!),
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
                        onPressed: comment!),
                    Text(
                      commentno!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    onPressed: share!),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
