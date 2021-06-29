import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/models/UserProfileModel/UserProfileModel.dart/UserProfileModel.dart';
import 'package:fosterhome/services/UserProfileServices/UserProfileServices.dart';

class FollowerHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  Widget main(BuildContext context, Future<UserProfileModel>? userProfileModel,
      bool isFollowing, String userID) {
    return FutureBuilder<UserProfileModel>(
      future: userProfileModel = UserProfileServices().getUserProfile(userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.data != null) {
          return ListView.builder(
              itemCount: snapshot.data!.booping!.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data!.boopers![index]);
                // return FutureBuilder<UserProfileModel>(
                //   future: userProfileModel = UserProfileServices()
                //       .getUserProfile(snapshot.data!.boopers![index]),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return CircularProgressIndicator();
                //     }
                //     if (snapshot.data!.boopers!.length == 0) {
                //       return Text("no followers");
                //     }
                //     if (snapshot.data!.boopers!.length != 0) {
                //       var contain = snapshot.data!.booping!
                //           .where((element) => element == userID);
                //       if (contain.isEmpty) {
                //         isFollowing = true;
                //       } else {
                //         isFollowing = false;
                //       }
                //       return ListTile(
                //         leading: CircleAvatar(
                //           backgroundImage: NetworkImage(
                //             snapshot.data!.profilePicture == ""
                //                 ? "https://source.unsplash.com/random"
                //                 : snapshot.data!.profilePicture!,
                //           ),
                //         ),
                //         title: Text(
                //           snapshot.data!.username!,
                //           style: TextStyle(
                //               color: constantColors.purple,
                //               fontWeight: FontWeight.w600),
                //         ),
                //         subtitle: Text(
                //           "${snapshot.data!.firstname!} ${snapshot.data!.lastname!}",
                //           style: TextStyle(
                //               fontWeight: FontWeight.w400, fontSize: 16),
                //         ),
                //         trailing:
                //             isFollowing ? Text("following") : Text("follow"),
                //       );
                //     } else {
                //       return CircularProgressIndicator();
                //     }
                //   },
                // );
              });
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
