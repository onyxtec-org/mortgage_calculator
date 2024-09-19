import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';
import '../constants/icons_constant.dart';
import '../constants/my_style.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.hint,
    this.onChanged,
    this.inputAction = TextInputAction.next,
    this.errorText,
  }) : super(key: key);

  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final void Function(String)? onChanged;
  final String? errorText;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: TextCapitalization.words,
        textInputAction: widget.inputAction,
        obscureText: _obscureText,
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        style: TextStyle(
          color: MyStyle.blackColor,
          fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.fourteen : MyStyle.eighteen,
          fontFamily: Constants.fontFamily,
        ),
        decoration: InputDecoration(
          errorText: widget.errorText,
          errorMaxLines: 3,
          hintText: widget.hint,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(
              IconsConstant.icLock,
              width: 20,
            ),
          ),
          hintStyle: const TextStyle(color: MyStyle.grayColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: MyStyle.lightGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: MyStyle.primaryColor),
          ),
          suffixIcon: IconButton(
            onPressed: _togglePasswordVisibility,
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: MyStyle.grayColor,
            ),
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
