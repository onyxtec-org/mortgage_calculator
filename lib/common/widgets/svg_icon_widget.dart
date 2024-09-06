import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/my_style.dart';

class SvgIconWidget extends StatelessWidget {
  const SvgIconWidget({
    super.key,
    required this.iconPath,
    this.iconSize = 24,
    this.iconsColor = MyStyle.primaryColor,
  });

  final String iconPath;
  final double? iconSize;
  final Color? iconsColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: iconSize,
      color: iconsColor,
    );
  }
}
