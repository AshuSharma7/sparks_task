import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sparkl_task/const/color.const.dart';

class FeatureCircleWidget extends StatelessWidget {
  final Widget child;
  final Animation<Offset> position;
  const FeatureCircleWidget(
      {super.key, required this.child, required this.position});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: position,
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 5,
        dashPattern: const [3, 4],
        padding: EdgeInsets.zero,
        color: AppColor.orange2,
        radius: const Radius.circular(50.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 8))
            ],
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.white60,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
