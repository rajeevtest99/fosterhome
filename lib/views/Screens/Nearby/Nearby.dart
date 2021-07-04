import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/AllUsersModel.dart';

import 'package:fosterhome/models/currentUser/currentUser.dart';

import 'package:fosterhome/services/UserProfileServices/getallUserServices.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/currentuser/currentuserServices.dart';

import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/usernamePrefs.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> with SingleTickerProviderStateMixin {
  bool loading = true;
  bool? update;
  final Api _api = Api();
  UserIdPref _idPref = UserIdPref();
  String? currentAddress = "my address";
  String? currentCity = "";
  double? latitude = 0;
  double? longitude = 0;
  String? currentCountry = "";
  Position? currentPositon;
  Future<GetAllUsers>? getAllUsersModel;
  Future<ProfileModel>? profileModel;

  final ConstantColors constantColors = ConstantColors();

  String? userID = '';
  bool isFollowing = false;
  String? userName = '';
  bool? display;
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
        latitude = position.latitude;
        longitude = position.longitude;

        currentAddress =
            "${place.locality} ${place.postalCode} ${place.country}";
        currentCity = place.locality;
        currentCountry = place.country;
        loading = true;
        update = true;

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
      "latitude": latitude,
      "longitude": longitude,
      "country": currentCountry,
      "city": currentCity
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

    Timer(Duration(milliseconds: 500), _determinePositon);
    Timer(Duration(milliseconds: 750), _updateLocation);
  }

  _checkUserID() async {
    userID = await (_idPref.readId(USER_ID_KEY));
    print(userID);
  }

  _checkUserName() async {
    userName = await _userNamePref.readUserName(USER_NAME_KEY);
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return FutureBuilder<ProfileModel>(
        future: profileModel = CurrentUserServices().getCurrentUserProfile(),
        builder: (context, usersnapshot) {
          if (usersnapshot.hasData) {
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "near $currentCity",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  : FutureBuilder<GetAllUsers>(
                      future: getAllUsersModel =
                          GetAllUserServices().getAllUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              LottieBuilder.asset(
                                "assets/lottie/location.json",
                                frameRate: FrameRate(60),
                              ),
                              Text(
                                "searching users",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "near $currentCity",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              )
                            ],
                          );
                        }
                        if (snapshot.hasData) {
                          void removeuser(userID) {
                            snapshot.data!.allusers!
                                .removeWhere((element) => element.id == userID);
                          }

                          removeuser(userID);

                          var userContains = snapshot.data!.allusers!
                              .where((element) => element.city == currentCity);

                          if (userContains.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  "assets/lottie/nonearby.json",
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                RichText(
                                    text: TextSpan(
                                  text: "Uh oh! no users",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                )),
                                RichText(
                                    text: TextSpan(
                                        text: "near ",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                        children: [
                                      TextSpan(
                                          text: "$currentCity",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: constantColors.purple))
                                    ])),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Image.asset(
                                          "assets/icons/pin.png",
                                          color: Colors.black,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
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
                                      itemCount:
                                          snapshot.data!.allusers!.length,
                                      itemBuilder: (context, index) {
                                        var users =
                                            snapshot.data!.allusers![index];

                                        if (users.city == currentCity) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                        userId: users.id,
                                                        size: users.hideSocial,
                                                        textlength: users
                                                            .about!.length
                                                            .toDouble(),
                                                      ),
                                                      type: PageTransitionType
                                                          .fade));
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
                                                    color:
                                                        constantColors.purple,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              subtitle: Text(
                                                "${users.firstname!} ${users.lastname!}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),
                              ],
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
            );
          } else {
            return Column(
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
            );
          }
        });
  }
}
