import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';

import '../common/constants/constants.dart';
import '../common/constants/icons_constant.dart';
import '../common/constants/my_style.dart';
import '../common/utils/utils.dart';
import '../common/widgets/text_input_field_widget.dart';
import '../common/widgets/elevated_button.dart';
import '../common/widgets/navigation_bar.dart';
import '../common/widgets/progress_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? _emailError;
  final TextEditingController _emailController = TextEditingController();

  void leftTapped() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NavBar(
              backIcon: IconsConstant.icBackArrow,
              titleText: 'Forgot Password',
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextView(
                            text: 'Please enter your register email address, so we will send you link to your email',
                            fontColor: MyStyle.darkGrayColor,
                            fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.sixteen : MyStyle.twenty,
                          ),
                          const SizedBox(height: 20),
                          TextInputFieldWidget(
                            controller: _emailController,
                            hint: Constants.emailHint,
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.done,
                            errorText: _emailError,
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _emailError = 'Please enter you registered email';
                                } else if (!Utils.emailRegex.hasMatch(value)) {
                                  _emailError = 'Please enter a valid email';
                                } else {
                                  _emailError = null;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Button(
                              onPressed: () {
                                _validateData();
                              },
                              text: "Submit")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _validateData() {
    String email = _emailController.text.trim();
    String? emailError;

    if (email.isEmpty) {
      emailError = 'Please enter you registered email';
    } else if (!Utils.emailRegex.hasMatch(email)) {
      emailError = 'Please enter a valid email';
    }
    setState(() {
      _emailError = emailError;
    });

    if (_emailError == null) {
      ProgressDialog.show(context, "Please wait...");
      Future.delayed(const Duration(seconds: 2), () {
        Utils.showToast("Email sent successfully");
        ProgressDialog.hide(context);
        Navigator.pop(context);
      });
    }
  }
}
