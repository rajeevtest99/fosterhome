import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/AllUsersModel.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';

import 'package:fosterhome/models/currentUser/currentUser.dart';

import 'package:fosterhome/services/UserProfileServices/getallUserServices.dart';
import 'package:fosterhome/services/api.dart';

import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/usernamePrefs.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile.dart';
import 'package:fosterhome/views/Screens/Profile/profile.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> with SingleTickerProviderStateMixin {
  bool loading = false;
  final Api _api = Api();
  UserIdPref _idPref = UserIdPref();
  String? currentAddress = "my address";
  String? currentCity = "";
  String? currentCountry = "";
  Position? currentPositon;
  Future<GetAllUsers>? getAllUsersModel;
  Future<ProfileModel>? profileModel;

  Future<UserProfileModel>? userProfileModel;
  final ConstantColors constantColors = ConstantColors();

  String? userID = '';
  bool isFollowing = false;
  String? userName = '';
  UserNamePref _userNamePref = UserNamePref();

  Future<Position?>? _determinePositon() async {
    bool? _serviceEnabled;
    LocationPermission _permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      Text("Please enable your location");
    }
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        Text("Location Permission Denied");
      }
    }
    if (_permission == LocationPermission.deniedForever) {
      Text("permission Denied Forever");
    }
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemark[0];

      setState(() {
        currentPositon = position;
        currentAddress =
            "${place.locality} ${place.postalCode} ${place.country}";
        currentCity = place.locality;
        currentCountry = place.country;
        loading = true;
        print(currentPositon);
      });
    } catch (err) {
      print(err);
    }
  }

  _updateLocation() async {
    String id = await _idPref.readId(USER_ID_KEY);
    Map<String, dynamic> updatelocation = {
      "userId": id,
      "latitude": currentPositon!.latitude.toString(),
      "longitude": currentPositon!.longitude.toString(),
      "city": currentCity,
      "country": currentCountry
    };
    var response = await _api.put("/user/$id/update", updatelocation);
    if (response.statusCode == 200) {
      String output = json.decode(response.body);
      setState(() {
        loading = false;
      });
      print(response.body);
      print(output);
    }
  }

  @override
  void initState() {
    super.initState();

    _checkUserID();
    _checkUserName();

    Timer(Duration(milliseconds: 300), _determinePositon);
    Timer(Duration(milliseconds: 1500), _updateLocation);
    getAllUsersModel = GetAllUserServices().getAllUsers();
  }

  _checkUserID() async {
    userID = await (_idPref.readId("userIdpass"));
    print(userID);
  }

  _checkUserName() async {
    userName = await _userNamePref.readUserName("userNamepass");
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Column(
              children: [
                LottieBuilder.asset(
                  "assets/lottie/location.json",
                  frameRate: FrameRate(60),
                ),
                Text(
                  "searching users",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Text(
                  "near $currentCity",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                )
              ],
            )
          : FutureBuilder<GetAllUsers>(
              future: getAllUsersModel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset(
                                "assets/icons/pin.png",
                                color: Colors.black,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                "users near $currentCity",
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
                            itemCount: snapshot.data!.allusers!.length,
                            itemBuilder: (context, index) {
                              var users = snapshot.data!.allusers![index];
                              if (users.city == currentCity &&
                                  users.id != userID) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        users.id == userID
                                            ? PageTransition(
                                                child: Profile(
                                                  userName: userName,
                                                ),
                                                type: PageTransitionType.fade)
                                            : PageTransition(
                                                child: AltProfile(
                                                  userId: users.id,
                                                  size: users.hideSocial,
                                                  textlength: users
                                                      .about!.length
                                                      .toDouble(),
                                                ),
                                                type: PageTransitionType.fade));
                                  },
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          users.profilePicture == ""
                                              ? "https://source.unsplash.com/random"
                                              : users.profilePicture!,
                                        ),
                                      ),
                                      title: Text(
                                        users.username!,
                                        style: TextStyle(
                                            color: constantColors.purple,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        "${users.firstname!} ${users.lastname!}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                      trailing: isFollowing
                                          ? following(users.id!)
                                          : follow(users.id!)),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
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
            getAllUsersModel = GetAllUserServices().getAllUsers();
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
            getAllUsersModel = GetAllUserServices().getAllUsers();
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
