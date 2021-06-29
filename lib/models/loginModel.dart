// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.userdata,
    this.token,
  });

  Userdata? userdata;
  String? token;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userdata: Userdata.fromJson(json["userdata"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userdata": userdata!.toJson(),
        "token": token,
      };
}

class Userdata {
  Userdata({
    this.profilePicture,
    this.boopers,
    this.booping,
    this.fostered,
    this.isAdmin,
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

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
        profilePicture: json["profilePicture"],
        boopers: List<String>.from(json["boopers"].map((x) => x)),
        booping: List<String>.from(json["booping"].map((x) => x)),
        fostered: json["fostered"],
        isAdmin: json["isAdmin"],
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
