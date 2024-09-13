import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/constants.dart';
import '../constants/my_style.dart';

class TextInputFieldWidget extends StatelessWidget {
  const TextInputFieldWidget(
      {Key? key,
      this.hint,
      required this.controller,
      required this.inputType,
      required this.inputAction,
      required this.onChanged,
      this.prefixIcon,
      this.suffixText,
      this.initialText,
      this.errorText})
      : super(key: key);

  final String? hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final void Function(String) onChanged;
  final String? prefixIcon;
  final String? suffixText;
  final String? initialText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: TextCapitalization.words,
        textInputAction: inputAction,
        keyboardType: inputType,
        onChanged: onChanged,
        style: TextStyle(
          color: MyStyle.primaryColor,
          fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.fourteen : MyStyle.eighteen,
          fontFamily: Constants.fontFamily,
        ),
        decoration: InputDecoration(
          hintText: hint ?? '',
          errorText: errorText,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SvgPicture.asset(
                    prefixIcon!,
                    color: MyStyle.grayColor,
                  ),
                )
              : null,
          suffixIcon: suffixText != null
              ? IntrinsicWidth(
                  // Dynamically adjust width based on text
                  child: Container(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        suffixText!,
                        style: TextStyle(
                          color: MyStyle.grayColor,
                          fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.fourteen : MyStyle.eighteen,
                        ),
                        overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                        maxLines: 1, // Limit to one line
                      ),
                    ),
                  ),
                )
              : null,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: MyStyle.lightGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: MyStyle.primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            // Border style for errors
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.red), // Customize error border color
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Border style for focused errors
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.red), // Customize focused error border color
          ),
        ),
      ),
    );
  }
}
