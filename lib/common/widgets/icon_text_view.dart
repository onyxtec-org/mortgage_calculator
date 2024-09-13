import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/widgets/ink_well_widget.dart';
import 'package:mortgage_calculator/common/widgets/svg_icon_widget.dart';

import '../constants/constants.dart';

class IconTextView extends StatelessWidget {
  const IconTextView({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.normal,
    this.underline = false,
    this.alignment = Alignment.centerLeft,
    this.isIcons = false,
    this.iconPath = IconsConstant.icExclamation,
    this.onTapIcon,
  });

  final String text;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final bool underline;
  final Alignment alignment;
  final String iconPath;
  final bool isIcons;
  final VoidCallback? onTapIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Row(
        children: [
          Text(
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
          if (isIcons)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWellWidget(
                onTap: onTapIcon!,
                child: SvgIconWidget(
                  iconPath: iconPath ?? '',
                  iconSize: 16,
                ),
              ),
            )
        ],
      ),
    );
  }
}
