import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fosterhome/consts/colors.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {this.firstname,
      this.lastname,
      this.profileP,
      this.time,
      this.username,
      this.like,
      this.description,
      this.tap,
      this.comment,
      this.share,
      this.commentno,
      this.likeno,
      this.image,
      this.animation,
      this.options});
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? profileP;
  final String? description;
  final String? time;
  final Function()? tap;
  final bool? like;
  final String? likeno;
  final String? commentno;
  final void Function()? comment;
  final void Function()? share;
  final Function? animation;

  final Container? image;
  final Widget? options;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  final ConstantColors constantColors = ConstantColors();
  late AnimationController? iconCont;
  late Animation<double>? iconAnim;

  bool? isLiked = true;

  @override
  void initState() {
    super.initState();
    iconCont = AnimationController(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        vsync: this);
    iconAnim = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 20, end: 26), weight: 26),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 26, end: 20), weight: 20)
    ]).animate(iconCont!);

    iconCont!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          widget.like!;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          widget.like!;
        });
      }
    });
  }

  void animation() {
    widget.like! ? iconCont!.reverse() : iconCont!.forward();
  }

  @override
  void dispose() {
    iconCont!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileP!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${widget.firstname!} ${widget.lastname!}",
                      style: TextStyle(
                          fontSize: 18,
                          color: constantColors.purple,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.grey,
                          size: MediaQuery.of(context).size.width * 0.035,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            widget.time!,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 1,
            ),
            widget.options!
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.description!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
        widget.image!,
        Container(
          /*decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 0.25, color: Colors.grey),
      )),*/
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                /*decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 0.5, color: Colors.grey))),*/
                width: MediaQuery.of(context).size.width * 0.315,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedBuilder(
                          animation: iconAnim!,
                          builder: (BuildContext context, _) {
                            return IconButton(
                                iconSize: iconAnim!.value,
                                icon: SvgPicture.asset(
                                  widget.like!
                                      ? "assets/icons/liked.svg"
                                      : "assets/icons/unlike.svg",
                                  height: iconAnim!.value,
                                  width: iconAnim!.value,
                                ),
                                onPressed: () {
                                  widget.tap!();
                                  setState(() {
                                    animation();
                                  });
                                });
                          }),
                    ),
                    Text(widget.likeno!),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SvgPicture.asset(
                            "assets/icons/comment.svg",
                            color: constantColors.purple,
                          ),
                        ),
                        onPressed: widget.comment!),
                    Text(
                      widget.commentno!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.315,
                /*decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(width: 0.5, color: Colors.grey))),*/
                child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(7.5),
                      child: SvgPicture.asset("assets/icons/share.svg",
                          color: constantColors.lightpurple),
                    ),
                    onPressed: widget.share!),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
