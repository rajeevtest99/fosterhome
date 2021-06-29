import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/views/signup/signup.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class LoginHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Widget welcomeLottie(BuildContext context) {
    return Lottie.asset("assets/lottie/welcome.json", width: 100, height: 100);
  }

  Widget eMail(BuildContext context, TextEditingController email) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextFormField(
          cursorHeight: 15,
          cursorColor: constantColors.purple,
          cursorWidth: 1,
          controller: email,
          textAlign: TextAlign.left,
          style: TextStyle(color: constantColors.lightpurple),
          decoration: InputDecoration(
              hintText: "Email",
              contentPadding: EdgeInsets.all(8.0),
              hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
              fillColor: constantColors.skyblue,
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

  Widget passWord(BuildContext context, TextEditingController password,
      String? errPassText) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextFormField(
            cursorHeight: 15,
            cursorColor: constantColors.purple,
            cursorWidth: 1,
            controller: password,
            textAlign: TextAlign.left,
            style: TextStyle(color: constantColors.lightpurple),
            decoration: InputDecoration(
                errorText: errPassText,
                hintText: "Password",
                contentPadding: EdgeInsets.all(8.0),
                hintStyle: TextStyle(color: constantColors.purple, height: 1.4),
                fillColor: constantColors.skyblue,
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

  Widget alreadyuser(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "New User?",
          style: TextStyle(
              fontSize: 18,
              color: constantColors.black,
              fontWeight: FontWeight.w200),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: SignUp(), type: PageTransitionType.leftToRight));
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: constantColors.lightpurple),
            ))
      ],
    );
  }

  Widget loginButton(BuildContext context, Function tap) {
    return GestureDetector(
      onTap: tap as void Function()?,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
            color: constantColors.purple,
            borderRadius: BorderRadius.circular(7.5)),
        child: Center(
            child: Text(
          'Login',
          style: TextStyle(
              color: constantColors.skyblue,
              fontSize: 28,
              fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
