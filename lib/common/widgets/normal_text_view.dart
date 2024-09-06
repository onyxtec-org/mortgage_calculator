import 'package:flutter/material.dart';

import '../constants/constants.dart';

class NormalTextView extends StatelessWidget {
  const NormalTextView({
    Key? key,
    required this.text,
    required this.color,
    required this.fontSize,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.normal,
    this.underline = false,
    this.alignment = Alignment.centerLeft,

  }) : super(key: key);

  final String text;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final bool underline;
  final Alignment alignment;


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: Constants.fontFamily,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: underline ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}
