import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';

class SelectableTextWidget extends StatelessWidget {
  final String text;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool isLeftRadius;

  const SelectableTextWidget({
    super.key,
    required this.text,
    required this.selectedColor,
    required this.onTap,
    required this.isLeftRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selectedColor, // Toggle color based on selection
          borderRadius: isLeftRadius
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ), // Custom border radius
        ),
        alignment: Alignment.center,
        child: TextView(
          text: text,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
