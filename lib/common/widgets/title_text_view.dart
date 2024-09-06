import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/my_style.dart';

class TitleTextView extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final double fontSize;
  final TextAlign textAlign;
  final Color fontColor;
  final FontWeight fontWeight;

  const TitleTextView(
      {super.key,
      required this.text,
      this.alignment = Alignment.centerLeft,
      this.fontSize = MyStyle.sixteen,
      this.textAlign = TextAlign.center,
      this.fontColor = MyStyle.primaryColor,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: fontSize, color: fontColor, fontFamily: Constants.fontFamily, fontWeight: fontWeight),
      ),
    );
  }
}
