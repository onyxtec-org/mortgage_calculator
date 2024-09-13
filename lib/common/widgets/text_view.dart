import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/my_style.dart';

class TextView extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final double fontSize;
  final TextAlign textAlign;
  final Color fontColor;
  final FontWeight fontWeight;
  final int? maxLines;

  const TextView({
    super.key,
    required this.text,
    this.alignment = Alignment.centerLeft,
    this.fontSize = MyStyle.sixteen,
    this.textAlign = TextAlign.center,
    this.fontColor = MyStyle.primaryColor,
    this.fontWeight = FontWeight.normal,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor,
          fontFamily: Constants.fontFamily,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
