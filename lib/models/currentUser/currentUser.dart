// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.data,
    this.username,
  });

  Data? data;
  String? username;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: Data.fromJson(json["data"]),
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "username": username,
      };
}

class Data {
  Data({
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
    this.password,
    this.createdAt,
    this.updatedAt,
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
  String? password;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? about;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
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
        "password": password,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "about": about,
      };
}
