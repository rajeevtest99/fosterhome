// To parse this JSON data, do
//
//     final getAllUsers = getAllUsersFromJson(jsonString);

import 'dart:convert';

GetAllUsers getAllUsersFromJson(String str) =>
    GetAllUsers.fromJson(json.decode(str));

String getAllUsersToJson(GetAllUsers data) => json.encode(data.toJson());

class GetAllUsers {
  GetAllUsers({
    this.allusers,
  });

  List<Alluser>? allusers;

  factory GetAllUsers.fromJson(Map<String, dynamic> json) => GetAllUsers(
        allusers: List<Alluser>.from(
            json["allusers"].map((x) => Alluser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "allusers": List<dynamic>.from(allusers!.map((x) => x.toJson())),
      };
}

class Alluser {
  Alluser({
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
  List<Boop>? boopers;
  List<Boop>? booping;
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

  factory Alluser.fromJson(Map<String, dynamic> json) => Alluser(
        profilePicture: json["profilePicture"],
        boopers:
            List<Boop>.from(json["boopers"].map((x) => boopValues.map![x])),
        booping:
            List<Boop>.from(json["booping"].map((x) => boopValues.map![x])),
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
        about: json["about"] == null ? null : json["about"],
      );

  Map<String, dynamic> toJson() => {
        "profilePicture": profilePicture,
        "boopers":
            List<dynamic>.from(boopers!.map((x) => boopValues.reverse[x])),
        "booping":
            List<dynamic>.from(booping!.map((x) => boopValues.reverse[x])),
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
        "about": about == null ? null : about,
      };
}

enum Boop {
  THE_60_A7_F80_D6_A41_CC05408077_B1,
  EMPTY,
  THE_60942_B05_DC092_C2_FF4_E9183_E,
  THE_60_A79_D3_BE1_C2680_BAC71_AD3_B
}

final boopValues = EnumValues({
  "": Boop.EMPTY,
  "60942b05dc092c2ff4e9183e": Boop.THE_60942_B05_DC092_C2_FF4_E9183_E,
  "60a79d3be1c2680bac71ad3b": Boop.THE_60_A79_D3_BE1_C2680_BAC71_AD3_B,
  "60a7f80d6a41cc05408077b1": Boop.THE_60_A7_F80_D6_A41_CC05408077_B1
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
