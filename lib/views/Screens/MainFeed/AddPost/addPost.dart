import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/supabase_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';

import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';

import 'package:image_picker/image_picker.dart';
import 'package:supabase/supabase.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  // const colors

  final ConstantColors constantColors = ConstantColors();

  // post text controller

  TextEditingController postCont = TextEditingController();

  //Api call

  final Api _api = Api();

  //get userID

  UserIdPref _idPref = UserIdPref();

  //Image PickedFile and image picker

  PickedFile? _image;

  final ImagePicker _picker = ImagePicker();

  //unused import of picked variable

  var pickedFile;

  //post id getter

  String? postid = "";

  //supabase url, key and client creation

  static String url = SUPABSE_URL;

  static String key = SUPABASE_KEY;

  final SupabaseClient client = SupabaseClient(url, key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  Map<String, dynamic> addPost = {
                    "description": postCont.text,
                    "userId": id
                  };

                  var response = await _api.post("/posts/create", addPost);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    print(response);
                    Map<String, dynamic> postOutput =
                        json.decode(response.body);
                    print(postOutput['_id']);
                    postid = postOutput['_id'];

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

                    if (_image != null) {
                      final file = File(_image!.path);
                      var res = await client.storage
                          .from('postuploads')
                          .upload(postid!, file);
                      print(res);
                      final urlres = await client.storage
                          .from('postuploads')
                          .createSignedUrl(postid!, 6480000000000000000);
                      print("${urlres.data}");
                      Map<String, dynamic> addImagepost = {
                        "image": urlres.data,
                        "userId": id
                      };
                      var imageupload =
                          await _api.put("posts/$postid/update", addImagepost);
                      if (imageupload.statusCode == 200 ||
                          imageupload.statusCode == 201) {
                        String postOutput = json.decode(imageupload.body);
                        print(postOutput);
                      }
                    }
                  }
                },
                child: Text("add post",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                fillColor: constantColors.lightpurple,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
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
                    controller: postCont,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "post something here",
                        contentPadding: EdgeInsets.all(8.0),
                        hintStyle: TextStyle(color: Colors.black, height: 1.4),
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
              _image == null
                  ? Container()
                  : Container(
                      child: Image(
                        image: FileImage(File(_image!.path)),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: constantColors.purple,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => selectPhoto(context)));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPhoto(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.225,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "choose your profile picture",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: constantColors.black,
                  fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      triggerImageAction(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.16,
                      decoration: BoxDecoration(
                        border: Border.all(color: constantColors.lightpurple),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: constantColors.purple,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () async {
                      /*var pickedfile = await FilePicker.platform
                          .pickFiles(allowMultiple: false);
                      setState(() {
                        pickedFile = pickedfile;
                      });*/
                      triggerImageAction(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: constantColors.lightpurple),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: constantColors.purple,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void triggerImageAction(ImageSource source) async {
    final pickedFile =
        await _picker.getImage(source: source, maxHeight: 640, maxWidth: 480);

    setState(() {
      _image = pickedFile;
    });
  }
}
