import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/my_style.dart';

class NavBar extends StatelessWidget {
  NavBar({
    Key? key,
    this.backIcon,
    this.onBackTap,
    this.titleText,
    this.icons,
    this.onIconTap,
    this.titleColor = MyStyle.primaryColor,
    this.iconsColor = MyStyle.primaryColor,
  }) : super(key: key);

  final String? backIcon;
  final String? titleText;
  final List<String>? icons;
  final Function(int)? onIconTap;
  final VoidCallback? onBackTap;
  final Color titleColor;
  final Color iconsColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          if (backIcon != null)
            Positioned(
              left: 0,
              child: IconButton(
                icon: SvgPicture.asset(
                  backIcon!,
                  height: 24,
                  width: 24,
                  color: iconsColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Text(
              titleText ?? "",
              style: TextStyle(
                fontSize: MyStyle.twenty,
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          if (icons != null)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  icons!.length,
                  (index) => IconButton(
                    icon: SvgPicture.asset(
                      icons![index],
                      height: 28,
                      width: 28,
                      color: iconsColor,
                    ),
                    onPressed: () {
                      if (onIconTap != null) {
                        onIconTap!(index);
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
