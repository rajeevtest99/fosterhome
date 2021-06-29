import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder? shapeBorder;

  const ShimmerWidget.rectangular({
    @required this.width,
    @required this.height,
  }) : this.shapeBorder = const RoundedRectangleBorder();
  const ShimmerWidget.circular(
      {@required this.width,
      @required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          height: height,
          width: width,
          decoration: ShapeDecoration(
              color: Color(0xffb8b5ff).withOpacity(0.3), shape: shapeBorder!),
        ),
        baseColor: Color(0xff7868e6),
        highlightColor: Color(0xffb8b5ff));
  }
}
