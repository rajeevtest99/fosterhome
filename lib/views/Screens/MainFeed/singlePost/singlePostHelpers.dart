import 'package:flutter/material.dart';
import 'package:fosterhome/consts/colors.dart';

class SinglePageHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  Widget comment(BuildContext context, String image, String name, String time,
      String comment) {
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: constantColors.purple),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(time,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(comment,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
