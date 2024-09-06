import 'package:flutter/material.dart';

import '../constants/my_style.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textColor = MyStyle.whiteColor,
    this.buttonColor = MyStyle.primaryColor,
    this.fontSize = MyStyle.sixteen,
    this.isEnabled = true,
    this.buttonHeight = 50,
    this.horizontalPadding = 10,
    this.verticalPadding = 0,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color buttonColor;
  final double fontSize;
  final bool isEnabled;
  final double buttonHeight;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      // width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          foregroundColor: textColor,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45.0),
          ),
        ),
        child: FittedBox(
          child: Text(
            text/*.toUpperCase()*/,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
