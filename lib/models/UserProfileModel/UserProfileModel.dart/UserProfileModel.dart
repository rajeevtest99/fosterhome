// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.profilePicture,
    this.boopers,
    this.booping,
    this.fostered,
    this.isAdmin,
    this.hasFostered,
    this.isWilling,
    this.hideSocial,
    this.hideLocation,
    this.instaId,
    this.instaLink,
    this.twitterId,
    this.twitterLink,
    this.fbId,
    this.fbLink,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.createdAt,
    this.v,
    this.about,
  });

  String? profilePicture;
  List<String>? boopers;
  List<String>? booping;
  String? fostered;
  bool? isAdmin;
  bool? hasFostered;
  bool? isWilling;
  bool? hideSocial;
  bool? hideLocation;
  String? instaId;
  String? instaLink;
  String? twitterId;
  String? twitterLink;
  String? fbId;
  String? fbLink;
  String? latitude;
  String? longitude;
  String? city;
  String? country;
  String? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  DateTime? createdAt;
  int? v;
  String? about;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        profilePicture: json["profilePicture"],
        boopers: List<String>.from(json["boopers"].map((x) => x)),
        booping: List<String>.from(json["booping"].map((x) => x)),
        fostered: json["fostered"],
        isAdmin: json["isAdmin"],
        hasFostered: json["hasFostered"],
        isWilling: json["isWilling"],
        hideSocial: json["hideSocial"],
        hideLocation: json["hideLocation"],
        instaId: json["instaId"],
        instaLink: json["instaLink"],
        twitterId: json["twitterId"],
        twitterLink: json["twitterLink"],
        fbId: json["fbId"],
        fbLink: json["fbLink"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        city: json["city"],
        country: json["country"],
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "profilePicture": profilePicture,
        "boopers": List<dynamic>.from(boopers!.map((x) => x)),
        "booping": List<dynamic>.from(booping!.map((x) => x)),
        "fostered": fostered,
        "isAdmin": isAdmin,
        "hasFostered": hasFostered,
        "isWilling": isWilling,
        "hideSocial": hideSocial,
        "hideLocation": hideLocation,
        "instaId": instaId,
        "instaLink": instaLink,
        "twitterId": twitterId,
        "twitterLink": twitterLink,
        "fbId": fbId,
        "fbLink": fbLink,
        "latitude": latitude,
        "longitude": longitude,
        "city": city,
        "country": country,
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "createdAt": createdAt!.toIso8601String(),
        "__v": v,
        "about": about,
      };
}
