import 'package:flutter/material.dart';
import 'package:fosterhome/Widgets/Postcard.dart';

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  bool like = false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return PostCard(
            firstname: "rajeev",
            lastname: "isukapatla",
            username: "rj21i",
            profileP: "https://source.unsplash.com/random",
            time: '5 pm',
            tap: () {},
            like: like,
            likeno: "2",
            share: () {},
            comment: () {},
            commentno: "5",
            image: Container(),
            description: "hellow i am under the water",
          );
        });
  }
}
