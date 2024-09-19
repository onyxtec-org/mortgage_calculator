import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';

import '../common/constants/constants.dart';
import '../common/constants/icons_constant.dart';
import '../common/constants/my_style.dart';
import '../common/utils/utils.dart';
import '../common/widgets/elevated_button.dart';
import '../common/widgets/ink_well_widget.dart';
import '../common/widgets/navigation_bar.dart';
import '../common/widgets/password_text_field.dart';
import '../common/widgets/progress_dialog.dart';
import '../common/widgets/text_input_field_widget.dart';
import '../network/network_call_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _errorMessage;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confPasswordError;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confPassController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              NavBar(backIcon: IconsConstant.icBackArrow, titleText: ""),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                            child: Column(
                              children: [
                                TextView(
                                  text: Constants.signUp,
                                  fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.twentyFour : MyStyle.twentyEight,
                                  fontColor: MyStyle.primaryColor,
                                  alignment: Alignment.centerLeft,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // name field
                                TextInputFieldWidget(
                                  controller: _nameController,
                                  inputType: TextInputType.text,
                                  hint: Constants.fullName,
                                  inputAction: TextInputAction.next,
                                  errorText: _nameError,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isNotEmpty) {
                                        _nameError = null;
                                      }
                                    });
                                  },
                                ),

                                // email field
                                TextInputFieldWidget(
                                  controller: _emailController,
                                  inputType: TextInputType.emailAddress,
                                  hint: Constants.emailHint,
                                  inputAction: TextInputAction.next,
                                  errorText: _emailError,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        _emailError = 'Please enter you email';
                                      } else if (!Utils.emailRegex.hasMatch(value)) {
                                        _emailError = 'Please enter a valid email';
                                      } else {
                                        _emailError = null;
                                      }
                                    });
                                  },
                                ),

                                // password field
                                PasswordTextField(
                                  controller: _passController,
                                  inputType: TextInputType.visiblePassword,
                                  hint: Constants.password,
                                  inputAction: TextInputAction.next,
                                  errorText: _passwordError,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        _passwordError = 'Please enter you password';
                                      } else if (!Utils.passwordRegex.hasMatch(value)) {
                                        _passwordError =
                                            'Please enter a password with at last 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.';
                                      } else {
                                        _passwordError = null;
                                      }
                                    });
                                  },
                                ),

                                // confirm password field
                                PasswordTextField(
                                  controller: _confPassController,
                                  inputType: TextInputType.visiblePassword,
                                  hint: Constants.confirmPassword,
                                  inputAction: TextInputAction.done,
                                  errorText: _confPasswordError,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      _confPasswordError = 'Please enter you password';
                                    } else if (!Utils.passwordRegex.hasMatch(value)) {
                                      _confPasswordError = Constants.passError;
                                    } else {
                                      _confPasswordError = null;
                                    }
                                  },
                                ),

                                const SizedBox(height: 20.0),

                                //Sign In button
                                Button(
                                  onPressed: () {
                                    _validateData();
                                  },
                                  text: Constants.signUp,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 60.0),

                        // if don't have an account field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              Constants.alreadyHaveAcc,
                              style: TextStyle(
                                fontSize: MyStyle.sixteen,
                                color: MyStyle.grayColor,
                              ),
                            ),
                            InkWellWidget(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                Constants.signIn,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: MyStyle.twenty,
                                  fontWeight: FontWeight.bold,
                                  color: MyStyle.primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateData() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    String confPassword = _confPassController.text.trim();

    String? nameError;
    String? emailError;
    String? passwordError;
    String? confPasswordError;

    if (name.isEmpty) {
      nameError = 'Please enter you name';
    }
    if (email.isEmpty) {
      emailError = 'Please enter you email';
    } else if (!Utils.emailRegex.hasMatch(email)) {
      emailError = 'Please enter a valid email';
    }
    if (password.isEmpty) {
      passwordError = 'Please enter you password';
    } else if (!Utils.passwordRegex.hasMatch(password)) {
      passwordError = 'Please enter a valid password';
    }
    if (confPassword.isEmpty) {
      confPasswordError = 'Please enter confirm password';
    } else if (password != confPassword) {
      confPasswordError = 'Confirm password doesn${"'"}t match';
    }

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confPasswordError = confPasswordError;
    });
    if (nameError == null && emailError == null && passwordError == null && confPasswordError == null) {
      ProgressDialog.show(context, "Please wait...");
      Future.delayed(const Duration(seconds: 2), () async {
        Utils.showToast('Success');
        ProgressDialog.hide(context);
        try {
          FormData body = FormData.fromMap({'name': name, 'email': email, 'password': password});

          var response = await NetworkCallManager().apiCall(endPoint: ApiEndPoints.login, queryParameters: null, body: body, header: null);
          if (response.statusCode == 201) {
            Map<String, dynamic> responseData = response.data;
            String message = responseData['message'];
            Utils.showToast(message);
            ProgressDialog.hide(context);
            Future.delayed(const Duration(milliseconds: 200), () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          } else {
            Map<String, dynamic> responseData = response.data;
            Utils.showToast(responseData['message']);
            ProgressDialog.hide(context);
          }
        } on DioException catch (e) {
          if (e.response != null) {
            // DioError with response
            print('DioError: ${e.response!.statusCode}');
            print('Response data: ${e.response!.data}');
            Map<String, dynamic> responseData = e.response!.data;
            Utils.showToast('${responseData['message']}');
          } else {
            // DioError without response
            print('DioError: ${e.message}');
            Utils.showToast('${e.message}');
          }
          ProgressDialog.hide(context);
        } catch (e) {
          print('Error: $e');
          Utils.showToast('Error: $e');
          ProgressDialog.hide(context);
        }
      });
    }
  }
}
