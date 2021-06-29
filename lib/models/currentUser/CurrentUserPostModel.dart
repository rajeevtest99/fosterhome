// To parse this JSON data, do
//
//     final currentUserPostModel = currentUserPostModelFromJson(jsonString);

import 'dart:convert';

CurrentUserPostModel currentUserPostModelFromJson(String str) =>
    CurrentUserPostModel.fromJson(json.decode(str));

String currentUserPostModelToJson(CurrentUserPostModel data) =>
    json.encode(data.toJson());

class CurrentUserPostModel {
  CurrentUserPostModel({
    this.data,
  });

  List<Datum>? data;

  factory CurrentUserPostModel.fromJson(Map<String, dynamic> json) =>
      CurrentUserPostModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.image,
    this.likes,
    this.id,
    this.description,
    this.userId,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? image;
  List<dynamic>? likes;
  String? id;
  String? description;
  String? userId;
  List<dynamic>? comments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        image: json["image"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        id: json["_id"],
        description: json["description"],
        userId: json["userId"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "_id": id,
        "description": description,
        "userId": userId,
        "comments": List<dynamic>.from(comments!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}
