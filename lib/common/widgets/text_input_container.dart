import 'package:flutter/material.dart';

import '../constants/my_style.dart';

class TextInputContainer extends StatefulWidget {
  final Widget child;
  final Color borderColor;
  final Color fillColor;

  const TextInputContainer({
    super.key,
    required this.child,
    this.borderColor = MyStyle.lightGrey,
    this.fillColor = MyStyle.backgroundColor,
  });

  @override
  _TextInputContainerState createState() => _TextInputContainerState();
}

class _TextInputContainerState extends State<TextInputContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: MyStyle.ten),
      height: 50,
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: widget.borderColor,
        ),
      ),
      child: widget.child,
    );
  }
}
