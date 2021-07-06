import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';
import 'package:fosterhome/views/login/login.dart';
import 'package:page_transition/page_transition.dart';

class SignUpHelpers extends ChangeNotifier {
  //consts Colors

  final ConstantColors constantColors = ConstantColors();

  Widget alreadyuser(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Already an User?",
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
                      child: Login(), type: PageTransitionType.leftToRight));
            },
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: constantColors.lightpurple),
            ))
      ],
    );
  }

  Widget signUpButton(BuildContext context, Function tap) {
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
          'Sign Up',
          style: TextStyle(
              color: constantColors.skyblue,
              fontSize: 28,
              fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
