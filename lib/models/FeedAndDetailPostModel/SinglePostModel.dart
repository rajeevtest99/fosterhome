// To parse this JSON data, do
//
//     final singlePost = singlePostFromJson(jsonString);

import 'dart:convert';

SinglePost singlePostFromJson(String str) =>
    SinglePost.fromJson(json.decode(str));

String singlePostToJson(SinglePost data) => json.encode(data.toJson());

class SinglePost {
  SinglePost({
    this.image,
    this.likes,
    this.id,
    this.userId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.comments,
  });

  String? image;
  List<String>? likes;
  String? id;
  String? userId;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<Comment>? comments;

  factory SinglePost.fromJson(Map<String, dynamic> json) => SinglePost(
        image: json["image"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        id: json["_id"],
        userId: json["userId"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "_id": id,
        "userId": userId,
        "description": description,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    this.comment,
    this.id,
    this.userId,
    this.updatedAt,
    this.createdAt,
  });

  String? comment;
  String? id;
  String? userId;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        id: json["_id"],
        userId: json["userId"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "_id": id,
        "userId": userId,
        "updatedAt": updatedAt!.toIso8601String(),
        "createdAt": createdAt!.toIso8601String(),
      };
}
