import 'package:flutter/material.dart';

import '../constants/my_style.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final bool isBorder;
  final Color borderColor;

  const BackgroundContainer({
    Key? key,
    required this.color,
    required this.borderRadius,
    required this.isBorder,
    required this.child,
    this.borderColor = MyStyle.greyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(width: isBorder ? 1 : 0, color: borderColor),
        color: color,
      ),
      child: child,
    );
  }
}
