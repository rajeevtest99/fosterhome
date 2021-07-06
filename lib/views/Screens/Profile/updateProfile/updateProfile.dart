import 'package:flutter/material.dart';
import 'package:fosterhome/models/currentUser/currentUser.dart';
import 'package:fosterhome/services/currentuser/currentuserServices.dart';
import 'package:fosterhome/views/Screens/Profile/updateProfile/updateProfile_helpers.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  //Api model

  Future<ProfileModel>? profileModel;

  @override
  void initState() {
    super.initState();
    profileModel = CurrentUserServices().getCurrentUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<ProfileModel>(
            future: profileModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Provider.of<UpdateProfileHelpers>(context, listen: true)
                        .addPhoto(context, snapshot),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Provider.of<UpdateProfileHelpers>(context,
                              listen: false)
                          .aboutField(context, snapshot),
                    ),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .hideSocial(context, snapshot),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .insta(context, snapshot),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .facebook(context, snapshot),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .twitter(context, snapshot),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .fosterdetails(context, snapshot),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .isWillingto(context),
                    Provider.of<UpdateProfileHelpers>(context, listen: false)
                        .nothing(context),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
