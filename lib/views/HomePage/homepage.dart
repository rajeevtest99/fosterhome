import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';

import 'package:fosterhome/models/currentUser/currentUser.dart';

import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/currentuser/currentuserServices.dart';

import 'package:fosterhome/services/token_id_username_prefs/usernamePrefs.dart';
import 'package:fosterhome/views/HomePage/SearchPage/SearchPage.dart';
import 'package:fosterhome/views/Screens/Global/global.dart';

import 'package:fosterhome/views/Screens/MainFeed/Feed.dart';
import 'package:fosterhome/views/Screens/Nearby/Nearby.dart';

import 'package:fosterhome/views/Screens/Profile/profile.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //textediting controller

  final TextEditingController searchText = TextEditingController();

  //consts Color

  final ConstantColors constantColors = ConstantColors();

  //logger

  var log = Logger();

  //reading secured keys for userName from SharedPrefs

  UserNamePref _userNamePref = UserNamePref();

  //profileModel

  Future<ProfileModel>? profileModel;

  //Api call

  final Api _api = Api();
  String? username = '';

  //TabBar controller

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    getUsername();

    profileModel = CurrentUserServices().getCurrentUserProfile();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  getUsername() async {
    username = await (_userNamePref.readUserName(USER_NAME_KEY));
    print(username);
  }

  checkUserData() async {
    var response = await _api.get("/user/getuser/$username");
    if (response == 200 || response == 201) {
      Map<String, dynamic>? data = json.decode(response);
      print(data);
      print(username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            child: Container(),
            preferredSize: MediaQuery.of(context).size * 0.025,
          ),
          title: Padding(
            padding:
                const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
            child: RichText(
                text: TextSpan(
                    text: 'Foster',
                    style: GoogleFonts.fredokaOne(
                        fontSize: 34, color: constantColors.lightpurple),
                    children: [
                  TextSpan(
                      text: 'Home',
                      style: GoogleFonts.fredokaOne(
                          fontSize: 38, color: constantColors.purple))
                ])),
          ),
          actions: [
            FutureBuilder<ProfileModel>(
              future: profileModel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Profile(
                                  userName: username,
                                ),
                                type: PageTransitionType.fade));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: constantColors.purple, width: 2)),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: constantColors.skyblue,
                          backgroundImage: NetworkImage(snapshot
                                      .data!.data!.profilePicture ==
                                  ""
                              ? "https://image.flaticon.com/icons/png/512/709/709722.png"
                              : snapshot.data!.data!.profilePicture!),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize: MediaQuery.of(context).size * 0.05,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showSearch(context: context, delegate: SearchPage());
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.0575,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: constantColors.purple, width: 0.5)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "assets/icons/search.svg",
                                  height: 25,
                                  width: 25,
                                  color: constantColors.lightpurple,
                                ),
                              ),
                              Text(
                                "search users",
                                style: TextStyle(
                                    color: constantColors.purple,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: constantColors.purple,
                        indicatorWeight: 4,
                        tabs: [
                          Tab(
                            child: Text(
                              "Global",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text("Feed",
                                style: TextStyle(color: Colors.black)),
                          ),
                          Tab(
                            child: Text("Nearby",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(controller: _tabController, children: [
            Global(),
            Feed(),
            Nearby(),
          ]),
        ),
        backgroundColor: constantColors.white,
      ),
    );
  }
}
