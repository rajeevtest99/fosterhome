import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fosterhome/Widgets/shimmerTile.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/FeedAndDetailPostModel/SinglePostModel.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';
import 'package:fosterhome/services/api.dart';

import 'package:fosterhome/services/post_FeedServices/singlePostService.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';

import 'package:fosterhome/views/Screens/MainFeed/singlePost/singlePostHelpers.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class SinglePostScreen extends StatefulWidget {
  final String? postID;

  SinglePostScreen({required this.postID});

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  //Api Call

  final Api _api = Api();

  //reading secured keys for userId from SharedPrefs

  UserIdPref _idPref = UserIdPref();

  //consts Colors

  final ConstantColors constantColors = ConstantColors();

  //Api Models

  Future<SinglePost>? singlePost;
  Future<UserProfileModel>? userProfileModel;

  //text contreoller

  TextEditingController commentCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    singlePost = SinglePostServices().singlePost(widget.postID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Container(
            child: Column(
              children: [
                Divider(
                  color: Colors.black45,
                  thickness: 2.5,
                  indent: 150,
                  endIndent: 150,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: FutureBuilder<SinglePost>(
                    future: singlePost,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.comments!.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.comments!.length,
                              itemBuilder: (context, index) {
                                var comments = snapshot.data!.comments![index];
                                return Container(
                                  child: Column(
                                    children: [
                                      FutureBuilder<UserProfileModel>(
                                        future: userProfileModel =
                                            UserProfileServices()
                                                .getUserProfile(
                                                    comments.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Provider
                                                    .of<
                                                            SinglePageHelpers>(
                                                        context,
                                                        listen: false)
                                                .comment(
                                                    context,
                                                    snapshot.data!
                                                                .profilePicture ==
                                                            ""
                                                        ? "https://image.flaticon.com/icons/png/512/709/709722.png"
                                                        : snapshot.data!
                                                            .profilePicture!,
                                                    "${snapshot.data!.firstname} ${snapshot.data!.lastname}",
                                                    timeago.format(comments
                                                        .createdAt!
                                                        .toLocal()),
                                                    comments.comment!);
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          return Center(
                              child: Text(
                            "no comments yet",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ));
                        }
                      } else {
                        return ListView.builder(
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading:
                                  ShimmerWidget.circular(width: 50, height: 50),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: ShimmerWidget.rectangular(
                                    width: MediaQuery.of(context).size.width *
                                        0.275,
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
                          },
                        );
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          cursorHeight: 15,
                          cursorColor: constantColors.purple,
                          cursorWidth: 1,
                          controller: commentCont,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintText: "add comment",
                              contentPadding: EdgeInsets.all(8.0),
                              hintStyle:
                                  TextStyle(color: Colors.black, height: 1.4),
                              fillColor: Colors.grey[200],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ))),
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      fillColor: constantColors.purple,
                      constraints: BoxConstraints.tight(Size(75, 35)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () async {
                        String? id = await (_idPref.readId(USER_ID_KEY));
                        Map<String, dynamic> comment = {
                          "comment": commentCont.text,
                          "userId": id
                        };
                        var response = await _api.post(
                            "/posts/${widget.postID}/comment", comment);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Map<String, dynamic>? loginoutput =
                              json.decode(response.body);
                          print(loginoutput);
                        }
                        setState(() {
                          singlePost =
                              SinglePostServices().singlePost(widget.postID);
                        });
                      },
                      child: Text(
                        "comment",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
