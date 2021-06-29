import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fosterhome/consts/colors.dart';

class SignUpTextFields extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  bool isVisibility = true;

  Widget firstName(
      BuildContext context, TextEditingController textEditingController) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "first name can't be empty";
            } else {
              return null;
            }
          },
          cursorHeight: 15,
          cursorColor: constantColors.purple,
          cursorWidth: 1,
          controller: textEditingController,
          textAlign: TextAlign.left,
          style: TextStyle(color: constantColors.lightpurple),
          decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 8, height: 0.5),
              hintText: "FirstName",
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    height: 5,
                    width: 5,
                    child: SvgPicture.asset(
                      "assets/icons/user-fh.svg",
                      height: 1.5,
                      width: 1.5,
                      color: constantColors.lightpurple,
                    )),
              ),
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
    );
  }

  Widget lastName(
      BuildContext context, TextEditingController textEditingController) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "last name can't be empty";
            } else {
              return null;
            }
          },
          cursorHeight: 15,
          cursorColor: constantColors.purple,
          cursorWidth: 1,
          controller: textEditingController,
          textAlign: TextAlign.left,
          style: TextStyle(color: constantColors.lightpurple),
          decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 8, height: 0.5),
              hintText: "LastName",
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    height: 5,
                    width: 5,
                    child: SvgPicture.asset(
                      "assets/icons/lastname.svg",
                      height: 1.5,
                      width: 1.5,
                      color: constantColors.lightpurple,
                    )),
              ),
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
    );
  }

  Widget userName(BuildContext context,
      TextEditingController textEditingController, String? error) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextFormField(
          cursorHeight: 15,
          cursorColor: constantColors.purple,
          cursorWidth: 1,
          controller: textEditingController,
          textAlign: TextAlign.left,
          style: TextStyle(color: constantColors.lightpurple),
          decoration: InputDecoration(
              errorText: error,
              errorStyle: TextStyle(fontSize: 8, height: 0.5),
              hintText: "UserName",
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    height: 5,
                    width: 5,
                    child: SvgPicture.asset(
                      "assets/icons/lastname.svg",
                      height: 1.5,
                      width: 1.5,
                      color: constantColors.lightpurple,
                    )),
              ),
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
    );
  }

  Widget eMail(BuildContext context,
      TextEditingController textEditingController, String? error) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextFormField(
          cursorHeight: 15,
          cursorColor: constantColors.purple,
          cursorWidth: 1,
          controller: textEditingController,
          textAlign: TextAlign.left,
          style: TextStyle(color: constantColors.lightpurple),
          decoration: InputDecoration(
              errorText: error,
              errorStyle: TextStyle(fontSize: 8, height: 0.5),
              hintText: "Email",
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    height: 2.5,
                    width: 2.5,
                    child: SvgPicture.asset(
                      "assets/icons/email.svg",
                      height: 1.5,
                      width: 1.5,
                      color: constantColors.lightpurple,
                    )),
              ),
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
    );
  }

  Widget passWord(
      BuildContext context, TextEditingController textEditingController) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Password can't be empty";
              }
              if (value.length < 8) {
                return "minimum 8 characters is required";
              } else {
                return null;
              }
            },
            obscureText: isVisibility,
            cursorHeight: 15,
            cursorColor: constantColors.purple,
            cursorWidth: 1,
            controller: textEditingController,
            textAlign: TextAlign.left,
            style: TextStyle(color: constantColors.lightpurple),
            decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 8, height: 0.5),
                suffixIcon: IconButton(
                  icon: isVisibility
                      ? Icon(
                          Icons.visibility_off,
                          color: constantColors.lightpurple,
                        )
                      : Icon(
                          Icons.visibility,
                          color: constantColors.purple,
                        ),
                  onPressed: () {
                    isVisibility = !isVisibility;
                    notifyListeners();
                  },
                ),
                hintText: "Password",
                contentPadding: EdgeInsets.all(8.0),
                hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                      height: 5,
                      width: 5,
                      child: SvgPicture.asset(
                        "assets/icons/password.svg",
                        height: 1.5,
                        width: 1.5,
                        color: constantColors.lightpurple,
                      )),
                ),
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
      ),
    );
  }
}
