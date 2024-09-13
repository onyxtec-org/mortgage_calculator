import 'package:flutter/material.dart';

import '../constants/my_style.dart';
import 'text_view.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    super.key,
    required this.titleText,
    required this.content,
    required this.pressedYes,
    this.pressedNo,
  });

  final String titleText;
  final String content;
  final void Function() pressedYes;
  final void Function()? pressedNo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          TextView(
            text: titleText,
            fontSize: MyStyle.sixteen,
            alignment: Alignment.center,
            fontColor: MyStyle.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextView(
            text: content,
            fontSize: MyStyle.fourteen,
            alignment: Alignment.center,
            fontColor: MyStyle.blackColor,
          ),
        ],
      ),
      actions: [
        if (pressedNo != null)
          TextButton(
            onPressed: pressedNo,
            child: const Text('No'),
          ),
        TextButton(
          onPressed: pressedYes,
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
