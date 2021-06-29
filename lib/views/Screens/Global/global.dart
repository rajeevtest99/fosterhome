import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/AllUsersModel.dart';
import 'package:fosterhome/models/currentUser/currentUser.dart';
import 'package:fosterhome/services/UserProfileServices/getallUserServices.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/views/Screens/Profile/altProfile/alt_profile.dart';
import 'package:page_transition/page_transition.dart';

class Global extends StatefulWidget {
  const Global({Key? key}) : super(key: key);

  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {
  Future<GetAllUsers>? getAllUsersModel;
  Future<ProfileModel>? profileModel;

  final ConstantColors constantColors = ConstantColors();

  String? userID = '';
  UserIdPref _idPref = UserIdPref();

  @override
  void initState() {
    // TODO: implement initState
    getAllUsersModel = GetAllUserServices().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GetAllUsers>(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          "assets/icons/pin.png",
                          color: Colors.black,
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          "users around the globe",
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
                        if (users.id != userID) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userId: users.id,
                                        size: users.hideSocial,
                                        textlength:
                                            users.about!.length.toDouble(),
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
                                    fontWeight: FontWeight.w400, fontSize: 16),
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
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
