import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosterhome/Widgets/shimmerTile.dart';

import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/searchModel/searchmodel.dart';
import 'package:fosterhome/services/SearchUser/SearchUserServices.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/usernamePrefs.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile.dart';
import 'package:fosterhome/views/Screens/Profile/profile.dart';
import 'package:page_transition/page_transition.dart';

class SearchPage extends SearchDelegate<Future<SearchUser?>?> {
  SearchPage({String hintText = "search users"})
      : super(
            searchFieldLabel: hintText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search);
  @override
  InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      hintStyle: TextStyle(color: _colors.lightpurple));

  final ConstantColors _colors = ConstantColors();
  Future<SearchUser?>? searchuser;
  bool isFollowing = false;

  final Api _api = Api();
  String? userID = '';
  String? userName = '';
  UserIdPref _idPref = UserIdPref();
  UserNamePref _userNamePref = UserNamePref();

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
    print(userID);
  }

  _checkUserName() async {
    userName = await _userNamePref.readUserName(USER_NAME_KEY);
    print(userName);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(
            Icons.clear,
            color: _colors.purple,
          ))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: _colors.purple,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<SearchUser?>(
        future: searchuser = SearchUserServices().searchuser(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.searchresult!.length,
                itemBuilder: (context, index) {
                  var searchresults = snapshot.data!.searchresult![index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          searchresults.profilePicture == ""
                              ? "https://source.unsplash.com/random"
                              : searchresults.profilePicture!),
                    ),
                    title: Text(searchresults.username!,
                        style: TextStyle(
                            color: _colors.purple,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      "${searchresults.firstname!} ${searchresults.lastname!}",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  );
                });
          } else {
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
              },
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _checkUserID();
    _checkUserName();
    return FutureBuilder<SearchUser?>(
        future: searchuser = SearchUserServices().searchuser(query),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return ListTile(
          //     leading: ShimmerWidget.circular(width: 50, height: 50),
          //     title: Align(
          //       alignment: Alignment.centerLeft,
          //       child: ShimmerWidget.rectangular(
          //           width: MediaQuery.of(context).size.width * 0.275,
          //           height: 10),
          //     ),
          //     subtitle: Align(
          //       alignment: Alignment.centerLeft,
          //       child: ShimmerWidget.rectangular(
          //           width: MediaQuery.of(context).size.width * 0.4, height: 10),
          //     ),
          //   );
          // }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.searchresult!.length,
                itemBuilder: (context, index) {
                  var searchresults = snapshot.data!.searchresult![index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: searchresults.id == userID
                                  ? Profile(userName: userName)
                                  : AltProfile(
                                      size: searchresults.hideSocial,
                                      userId: searchresults.id,
                                      textlength: searchresults.about!.length
                                          .toDouble(),
                                    ),
                              type: PageTransitionType.leftToRight));
                      // MaterialPageRoute(
                      //     builder: (context) => AltProfile(
                      //         userId: searchresults.id,
                      //         size: searchresults.hideSocial,
                      //         textlength:
                      //             searchresults.about!.length.toDouble())));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            searchresults.profilePicture == ""
                                ? "https://source.unsplash.com/random"
                                : searchresults.profilePicture!),
                      ),
                      title: Text(searchresults.username!,
                          style: TextStyle(
                              color: _colors.purple,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "${searchresults.firstname!} ${searchresults.lastname!}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                  );
                });
          } else {
            return ListView.builder(
              itemCount: 7,
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
              },
            );
          }
        });
  }
}
