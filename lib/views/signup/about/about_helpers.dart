import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/consts/supabase_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/services/api.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase/supabase.dart';

class AboutHelpers extends ChangeNotifier {
  // have you fostered?

  String firstVal = '';
  bool showNoofpets = false;

  //no of pets

  int noofpets = 0;
  bool moreThan5 = false;

  //is willing logic
  String isWill = '';
  bool isWilling = false;

  //api call

  final Api _api = Api();

  // const colors

  final ConstantColors constantColors = ConstantColors();

  //read user and token

  PrefService _prefService = PrefService();
  UserIdPref _idPref = UserIdPref();

  //loading

  bool isLoading = false;
  final spinkit = SpinKitThreeBounce(
    color: Colors.purple,
  );

  //about text controller

  final TextEditingController about = TextEditingController();

  final TextEditingController _noofpetsCont = TextEditingController();

  //social Controllers

  // insta

  final TextEditingController _instaID = TextEditingController();

  final TextEditingController _instaLink = TextEditingController();

  // fb

  final TextEditingController _fbID = TextEditingController();

  final TextEditingController _fbLink = TextEditingController();

  // twitter

  final TextEditingController _twitterID = TextEditingController();

  final TextEditingController _twitterLink = TextEditingController();

  bool? hideSocialMedia = true;

  //image picking

  PickedFile? _image;
  final ImagePicker _picker = ImagePicker();

  //supabase url, key and client creation

  static String url = SUPABSE_URL;

  static String key = SUPABASE_KEY;

  final SupabaseClient client = SupabaseClient(url, key);

  Widget addPhoto(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: (_image == null
                  ? AssetImage("assets/images/user.png")
                  : FileImage(File(_image!.path))) as ImageProvider<Object>?,
              backgroundColor: constantColors.skyblue,
              radius: 60,
            ),
            Positioned(
                top: 72,
                left: 67.5,
                child: Container(
                  decoration: BoxDecoration(
                      color: constantColors.white, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: constantColors.lightpurple,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: ((builder) => selectPhoto(context)));
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget aboutField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 25,
        left: 5,
        right: 5,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.1, left: 2, right: 2, bottom: 55),
              child: SizedBox(
                height: 25,
                width: 25,
                child: SvgPicture.asset(
                  "assets/icons/about.svg",
                  color: constantColors.lightpurple,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.01,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: constantColors.lightpurple),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                cursorHeight: MediaQuery.of(context).size.height * 0.025,
                cursorColor: constantColors.purple,
                cursorWidth: 1,
                controller: about,
                textAlign: TextAlign.left,
                focusNode: FocusNode(canRequestFocus: true),
                style: TextStyle(color: constantColors.black),
                maxLength: 250,
                maxLines: 5,
                decoration: InputDecoration(
                    counterStyle: TextStyle(
                        color: constantColors.lightpurple,
                        height: MediaQuery.of(context).size.height * 0.0014),
                    hintText: "Tell us something about you",
                    contentPadding: EdgeInsets.all(8.0),
                    hintStyle: TextStyle(
                        color: constantColors.lightpurple,
                        height: MediaQuery.of(context).size.height * 0.0025),
                    labelStyle: TextStyle(
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
          ],
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
                    onTap: () {
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
    final pickedFile = await _picker.getImage(source: source);

    _image = pickedFile;
    notifyListeners();
  }

  Widget nothing(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: isLoading
          ? spinkit
          : Center(
              child: GestureDetector(
                onTap: () async {
                  isLoading = true;
                  notifyListeners();
                  String? token = await (_prefService.readCache(TOKEN_KEY));
                  String? id = await (_idPref.readId(USER_ID_KEY));
                  if (_image != null) {
                    final file = File(_image!.path);
                    var res = await client.storage
                        .from('profileuploads')
                        .upload(id!, file);
                    print(res);
                    final urlres = await client.storage
                        .from('profileuploads')
                        .createSignedUrl(id, 6480000000000000000);
                    print("${urlres.data}");

                    Map<String, dynamic> imageurl = {
                      "profilePicture": urlres.data,
                      "userId": id
                    };

                    var updateprofile =
                        await _api.put("user/$id/update", imageurl);
                    if (updateprofile.statusCode == 200 ||
                        updateprofile.statusCode == 201) {
                      String response = json.decode(updateprofile.body);
                      print(response);
                    }
                  }
                  if (about.text != "") {
                    Map<String, dynamic> aboutAdd = {
                      "about": about.text,
                      "userId": id
                    };
                    var updateAbout =
                        await _api.put("user/$id/update", aboutAdd);
                    if (updateAbout.statusCode == 200 ||
                        updateAbout.statusCode == 201) {
                      String response = json.decode(updateAbout.body);
                      print(response);
                    }
                  }

                  if (showNoofpets == true) {
                    Map<String, dynamic> addShowNoofPets = {
                      "hasFostered": true,
                      "fostered": "$noofpets",
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addShowNoofPets);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }
                  if (moreThan5 == true) {
                    Map<String, dynamic> addMorethan5 = {
                      "hasFostered": true,
                      "fostered": _noofpetsCont.text,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addMorethan5);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }
                  if (isWilling == true) {
                    Map<String, dynamic> addisWilling = {
                      "isWilling": true,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addisWilling);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }

                  if (_instaID.text != "") {
                    Map<String, dynamic> addinstaID = {
                      "instaId": _instaID.text,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addinstaID);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }
                  if (_instaLink.text != "") {
                    Map<String, dynamic> addinstaLink = {
                      "instaLink": _instaLink.text,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addinstaLink);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }
                  if (_fbID.text != "") {
                    Map<String, dynamic> addfbID = {
                      "fbId": _fbID.text,
                      "userId": id
                    };
                    var response = await _api.put("user/$id/update", addfbID);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }

                  if (_fbLink.text != "") {
                    Map<String, dynamic> addfbLink = {
                      "fbLink": _fbLink.text,
                      "userId": id
                    };
                    var response = await _api.put("user/$id/update", addfbLink);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }
                  if (_twitterID.text != "") {
                    Map<String, dynamic> addtwitterId = {
                      "twitterId": _twitterID.text,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addtwitterId);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }
                  if (_twitterLink.text != "") {
                    Map<String, dynamic> addtwitterLink = {
                      "twitterLink": _twitterLink.text,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", addtwitterLink);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }

                  if (hideSocialMedia == false) {
                    Map<String, dynamic> hideSocial = {
                      "hideSocial": false,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", hideSocial);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  } else {
                    Map<String, dynamic> hideSocial = {
                      "hideSocial": true,
                      "userId": id
                    };
                    var response =
                        await _api.put("user/$id/update", hideSocial);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      String updatedResult = json.decode(response.body);
                      print(updatedResult);
                    }
                  }

                  isLoading = false;
                  notifyListeners();
                  print(token);
                  print(id);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: constantColors.lightpurple),
                  child: Center(
                      child: Text(
                    "Submit",
                    style: TextStyle(
                        color: constantColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  )),
                ),
              ),
            ),
    );
  }

  Widget fosterdetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "have you fostered a pet before? ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                Radio(
                    activeColor: constantColors.purple,
                    value: 'yes',
                    groupValue: firstVal,
                    onChanged: (val) {
                      firstVal = 'yes';
                      showNoofpets = true;
                      notifyListeners();
                      print(showNoofpets);
                    }),
                Text(
                  "Yes",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            Row(
              children: [
                Radio(
                    activeColor: constantColors.purple,
                    value: 'no',
                    groupValue: firstVal,
                    onChanged: (value) {
                      firstVal = 'no';
                      showNoofpets = false;
                      moreThan5 = false;
                      notifyListeners();
                      print(showNoofpets);
                    }),
                Text(
                  "No",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            showNoofpets ? noOfPets(context) : Container(),
            moreThan5 ? typeNoOfPets(context) : Container()
          ],
        ),
      ),
    );
  }

  Widget noOfPets(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("how many pets have you fostered?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          ),
          Row(
            children: [
              Radio(
                  activeColor: constantColors.purple,
                  value: 1,
                  groupValue: noofpets,
                  onChanged: (val) {
                    noofpets = 1;
                    moreThan5 = false;
                    notifyListeners();
                    print(noofpets);
                  }),
              Text(
                "1",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                  activeColor: constantColors.purple,
                  value: 2,
                  groupValue: noofpets,
                  onChanged: (val) {
                    noofpets = 2;
                    moreThan5 = false;
                    notifyListeners();
                    print(noofpets);
                  }),
              Text(
                "2",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                  activeColor: constantColors.purple,
                  value: 3,
                  groupValue: noofpets,
                  onChanged: (val) {
                    noofpets = 3;
                    moreThan5 = false;
                    notifyListeners();
                    print(noofpets);
                  }),
              Text(
                "3",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                  activeColor: constantColors.purple,
                  value: 4,
                  groupValue: noofpets,
                  onChanged: (val) {
                    noofpets = 4;
                    moreThan5 = false;
                    notifyListeners();
                    print(noofpets);
                  }),
              Text(
                "4",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                  activeColor: constantColors.purple,
                  value: 5,
                  groupValue: noofpets,
                  onChanged: (val) {
                    noofpets = 5;
                    moreThan5 = true;
                    notifyListeners();
                    print(noofpets);
                  }),
              Text(
                "more than 5",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget typeNoOfPets(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Please mention the number of pets you have fostered",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 15,
              left: 10,
              right: 10,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: TextFormField(
                cursorHeight: 15,
                cursorColor: constantColors.purple,
                cursorWidth: 1,
                controller: _noofpetsCont,
                textAlign: TextAlign.left,
                style: TextStyle(color: constantColors.lightpurple),
                decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 8, height: 0.5),
                    hintText: "No. of Pets",
                    contentPadding: EdgeInsets.all(8.0),
                    hintStyle:
                        TextStyle(color: constantColors.purple, height: 1.4),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: constantColors.lightpurple,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: constantColors.purple,
                        ))),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget isWillingto(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "are you willing to adopt/foster a pet?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                Radio(
                    activeColor: constantColors.purple,
                    value: 'yes',
                    groupValue: isWill,
                    onChanged: (val) {
                      isWill = 'yes';
                      isWilling = true;
                      notifyListeners();
                      print(isWilling);
                    }),
                Text(
                  "Yes",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            Row(
              children: [
                Radio(
                    activeColor: constantColors.purple,
                    value: 'no',
                    groupValue: isWill,
                    onChanged: (value) {
                      isWill = 'no';
                      isWilling = false;
                      notifyListeners();
                      print(isWilling);
                    }),
                Text(
                  "No",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget insta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Image.asset(
                  "assets/icons/insta.png",
                  height: MediaQuery.of(context).size.height * 0.045,
                  color: constantColors.purple,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w600),
                        controller: _instaID,
                        cursorColor: constantColors.lightpurple,
                        decoration: InputDecoration(
                            hintText: "insta ID",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: _instaLink,
                        cursorColor: constantColors.lightpurple,
                        decoration: InputDecoration(
                            hintText: "insta link",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget facebook(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Image.asset(
                  "assets/icons/fb.png",
                  height: MediaQuery.of(context).size.height * 0.045,
                  color: constantColors.purple,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextFormField(
                        controller: _fbID,
                        cursorColor: constantColors.lightpurple,
                        decoration: InputDecoration(
                            hintText: "facebook",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: _fbLink,
                        cursorColor: constantColors.lightpurple,
                        decoration: InputDecoration(
                            hintText: "facebook link",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget twitter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Image.asset(
                  "assets/icons/twitter.png",
                  height: MediaQuery.of(context).size.height * 0.045,
                  color: constantColors.purple,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextFormField(
                        controller: _twitterID,
                        cursorColor: constantColors.lightpurple,
                        decoration: InputDecoration(
                            hintText: "twitter ID",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: _twitterLink,
                        cursorColor: constantColors.lightpurple,
                        decoration: InputDecoration(
                            hintText: "twitter link",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget hideSocial(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "hide Social Media handles ?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Switch(
              activeColor: constantColors.purple,
              activeTrackColor: constantColors.purple.withOpacity(0.5),
              inactiveThumbColor: constantColors.lightpurple,
              inactiveTrackColor: constantColors.lightpurple.withOpacity(0.5),
              value: hideSocialMedia!,
              onChanged: (value) {
                hideSocialMedia = value;
                notifyListeners();
                print(value);
              })
        ],
      ),
    );
  }
}
