import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/utils/shared_pref_helper.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import 'package:mortgage_calculator/home_screen.dart';
import 'package:mortgage_calculator/models/user_model.dart';

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
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confPasswordError;
  String? password;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
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
                                // first name field
                                TextInputFieldWidget(
                                  controller: _firstNameController,
                                  inputType: TextInputType.text,
                                  hint: Constants.firstName,
                                  inputAction: TextInputAction.next,
                                  prefixIcon: IconsConstant.icMessage,
                                  errorText: _firstNameError,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isNotEmpty) {
                                        _firstNameError = null;
                                      }
                                    });
                                  },
                                ),

                                // last name field
                                TextInputFieldWidget(
                                  controller: _lastNameController,
                                  inputType: TextInputType.text,
                                  hint: Constants.lastName,
                                  inputAction: TextInputAction.next,
                                  prefixIcon: IconsConstant.icMessage,
                                  errorText: _lastNameError,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isNotEmpty) {
                                        _lastNameError = null;
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
                                  prefixIcon: IconsConstant.icMessage,
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
                                      password = value;
                                      if (value.isEmpty) {
                                        _passwordError = 'Please enter you password';
                                      } else if (password!.length < 8) {
                                        _passwordError = 'Password must at least 8 characters';
                                      }
                                      /*else if (!Utils.passwordRegex.hasMatch(value)) {
                                        _passwordError =
                                            'Please enter a password with at last 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.';
                                      } */
                                      else {
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
                                    setState(() {
                                      if (value.isEmpty) {
                                        _confPasswordError = 'Please enter confirm password';
                                      } else if (password != _confPassController.text) {
                                        _confPasswordError = 'Your confirm password doesn${"'"}t match password';
                                      } else {
                                        _confPasswordError = null;
                                      }
                                    });
                                  },
                                ),

                                const SizedBox(height: 20.0),

                                //Sign Up button
                                SizedBox(
                                  width: double.infinity,
                                  child: Button(
                                    onPressed: () {
                                      _validateData();
                                    },
                                    text: Constants.signUp,
                                    fontSize: 18,
                                  ),
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

  Future<void> _validateData() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    String confPassword = _confPassController.text.trim();

    String? firstNameError;
    String? lastNameError;
    String? emailError;
    String? passwordError;
    String? confPasswordError;

    if (firstName.isEmpty) {
      firstNameError = 'Please enter you first name';
    }
    if (lastName.isEmpty) {
      lastNameError = 'Please enter you last name';
    }
    if (email.isEmpty) {
      emailError = 'Please enter you email';
    } else if (!Utils.emailRegex.hasMatch(email)) {
      emailError = 'Please enter a valid email';
    }
    if (password.isEmpty) {
      passwordError = 'Please enter you password';
    } else if (password.length < 8) {
      passwordError = 'Password must at leas 8 characters';
    }
    /*else if (!Utils.passwordRegex.hasMatch(password)) {
      // passwordError = 'Please enter a valid password';
    }*/
    if (confPassword.isEmpty) {
      confPasswordError = 'Please enter confirm password';
    } else if (password != confPassword) {
      confPasswordError = 'Confirm password doesn${"'"}t match';
    }

    setState(() {
      _firstNameError = firstNameError;
      _lastNameError = lastNameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confPasswordError = confPasswordError;
    });
    if (firstNameError == null && lastNameError == null && emailError == null && passwordError == null && confPasswordError == null) {
      ProgressDialog.show(context, "Please wait...");
      try {
        FormData body = FormData.fromMap({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        });

        var response = await NetworkCallManager().apiCall(endPoint: ApiEndPoints.signup, queryParameters: null, body: body, header: null);
        Map<String, dynamic> responseData = response;

        String message = responseData['message'];
        Utils.showToast(message);
        ProgressDialog.hide(context);
        Map<String, dynamic> userData = responseData['data']['user'];
        UserModel userModel = UserModel.fromJson(userData);
        String token = responseData['data']['token'];
        SharedPrefHelper.saveStringValues(Constants.authToken, token);
        SharedPrefHelper.saveUser(userModel);
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to Home
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        });
      } on DioException catch (e) {
        if (e.response != null) {
          // DioError with response
          Map<String, dynamic> responseData = e.response!.data;

          // Handle nested error for email
          if (responseData.containsKey('email')) {
            List<dynamic> emailErrors = responseData['email'];
            Utils.showToast(emailErrors.join(', ')); // Display all email error messages
          } else {
            Utils.showToast('An error occurred');
          }
        } else {
          // DioError without response
          Utils.showToast('${e.message}');
        }
        ProgressDialog.hide(context);
      } catch (e) {
        Utils.showToast('Error: $e');
        ProgressDialog.hide(context);
      }
    }
  }
}
