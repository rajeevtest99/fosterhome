import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/FeedAndDetailPostModel/SinglePostModel.dart';

import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/post_FeedServices/singlePostService.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:fosterhome/views/HomePage/homepage.dart';

import 'package:page_transition/page_transition.dart';

class UpdatePost extends StatefulWidget {
  const UpdatePost({Key? key, @required this.postId}) : super(key: key);
  final String? postId;

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  // const colors

  final ConstantColors constantColors = ConstantColors();

  // post text controller

  TextEditingController updatePostCont = TextEditingController();

  //Api call

  final Api _api = Api();

  //get userID

  UserIdPref _idPref = UserIdPref();

  //Image PickedFile and image picker

  // PickedFile? _image;

  // final ImagePicker _picker = ImagePicker();

  //unused import of picked variable

  // var pickedFile;

  //post id getter

  String? postid = "";

  //post Model

  Future<SinglePost?>? singlepost;

  @override
  void initState() {
    super.initState();
    singlepost = SinglePostServices().singlePost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: constantColors.purple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawMaterialButton(
              constraints: BoxConstraints.tight(Size(90, 5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () async {
                String? id = await (_idPref.readId(USER_ID_KEY));
                Map<String, dynamic> updatePost = {
                  "description": updatePostCont.text,
                  "userId": id
                };

                var response = await _api.put(
                    "/posts/${widget.postId}/update", updatePost);
                if (response.statusCode == 200 || response.statusCode == 201) {
                  print(response);
                  String postOutput = json.decode(response.body);
                  print(postOutput);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.leftToRight));

                  // how to upload files to supabase

                  /*if (pickedFile != null) {
                    final file = File(pickedFile.files.first.path!);
                    var res = await client.storage
                        .from('postuploads')
                        .upload(pickedFile.files.first.name, file);
                    print(res);
                    final urlres = await client.storage
                        .from('postuploads')
                        .createSignedUrl(pickedFile.files.first.name, 60);
                    print("${urlres.data}");
                  }*/

                }
              },
              child: Text("update",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              fillColor: constantColors.lightpurple,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<SinglePost?>(
          future: singlepost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              updatePostCont.text = snapshot.data!.description! == ""
                  ? ""
                  : snapshot.data!.description!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.125,
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 5,
                        cursorHeight: 15,
                        cursorColor: constantColors.purple,
                        cursorWidth: 1,
                        controller: updatePostCont,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "post something here",
                            contentPadding: EdgeInsets.all(8.0),
                            hintStyle:
                                TextStyle(color: Colors.black, height: 1.4),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ))),
                      ),
                    ),
                  ),
                  snapshot.data!.image! != ""
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("you cannot update your post Image"),
                        )
                      : Container(),
                  snapshot.data!.image! != ""
                      ? Container(
                          child: Image.network(snapshot.data!.image!),
                        )
                      : Container()
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
