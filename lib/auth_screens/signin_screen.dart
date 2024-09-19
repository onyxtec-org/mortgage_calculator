import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import '../common/constants/constants.dart';
import '../common/constants/icons_constant.dart';
import '../common/constants/my_style.dart';
import '../common/utils/shared_pref_helper.dart';
import '../common/utils/utils.dart';
import '../common/widgets/elevated_button.dart';
import '../common/widgets/ink_well_widget.dart';
import '../common/widgets/password_text_field.dart';
import '../common/widgets/progress_dialog.dart';
import '../common/widgets/switch_button.dart';
import '../common/widgets/text_input_field_widget.dart';
import '../network/api_error_handler.dart';
import '../network/network_call_manager.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? _emailError;
  String? _passwordError;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isNotRemembered = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: screenSize.width > 600.0 ? 180.0 : 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/ic-logo.png',
                  width: 84,
                  height: 84,
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        TextView(
                          text: Constants.signIn,
                          fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.twentyFour : MyStyle.twentyEight,
                          fontColor: MyStyle.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 20,
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
                                _emailError = 'Please enter email';
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
                          inputAction: TextInputAction.done,
                          errorText: _passwordError,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _passwordError = 'Please enter your password';
                              } else if (!Utils.passwordRegex.hasMatch(value)) {
                                _passwordError = Constants.passError;
                              } else {
                                _passwordError = null;
                              }
                            });
                          },
                        ),

                        // Remember password fields
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0, top: 10.0),
                          child: Row(
                            children: [
                              StyledSwitch(onToggled: (value) {}),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextView(
                                  text: 'Remember Me',
                                  fontColor: MyStyle.darkGrayColor,
                                  fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.fourteen : MyStyle.eighteen,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              //forgot password
                              InkWellWidget(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                                },
                                child: TextView(
                                  text: Constants.forgotPass,
                                  fontColor: MyStyle.darkGrayColor,
                                  fontSize: MediaQuery.of(context).size.width < 600 ? MyStyle.fourteen : MyStyle.eighteen,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Sign In button
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                            onPressed: () {
                              _validateData();
                            },
                            text: Constants.signIn,
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
                      Constants.dontHaveAcc,
                      style: TextStyle(
                        fontSize: MyStyle.sixteen,
                        color: MyStyle.grayColor,
                      ),
                    ),
                    InkWellWidget(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        Constants.signUp,
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
    );
  }

  Future<void> _validateData() async {
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    String? emailError;
    String? passwordError;

    if (email.isEmpty) {
      emailError = 'Please enter email';
    } else if (!Utils.emailRegex.hasMatch(email)) {
      emailError = 'Please enter a valid email';
    }

    if (password.isEmpty) {
      passwordError = 'Please enter your password';
    } else if (!Utils.passwordRegex.hasMatch(password)) {
      passwordError = 'Please enter a valid password';
    }

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    if (emailError == null && passwordError == null) {
      // Perform login or other action
      ProgressDialog.show(context, "Please wait...");
      try {
        FormData body = FormData.fromMap({'email': email, 'password': password});
        var response = await NetworkCallManager().apiCall(endPoint: ApiEndPoints.signup, queryParameters: null, body: body, header: null);

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          String bearerToken = responseData['bearer_token'];
          Map<String, dynamic> user = responseData['user'];
          // UserModel userModel = UserModel.fromJson(user);
          // UserSingleton().setUser(userModel);
          // SharedPrefHelper.saveUser(userModel);

          if (!isNotRemembered) {
            SharedPrefHelper.saveBooleanValues(Constants.isNotRemember, false);
            SharedPrefHelper.saveStringValues(Constants.rememberEmail, email);
            SharedPrefHelper.saveStringValues(Constants.rememberPassword, password);
          } else {
            SharedPrefHelper.saveBooleanValues(Constants.isNotRemember, true);
            SharedPrefHelper.saveStringValues(Constants.rememberEmail, null);
            SharedPrefHelper.saveStringValues(Constants.rememberPassword, null);
          }
          // Save bearer token to shared preferences
          SharedPrefHelper.saveStringValues(Constants.authToken, bearerToken);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const MainController()));
        }
      } on DioException catch (e) {
        ProgressDialog.hide(context);
        print('DioError: ${e.response!.statusCode}');

        Map<String, dynamic> responseData = e.response!.data;
        if (responseData['message'] == 'Email is not verified. Please verify your email to login.') {
          _emailValidationDialog();
          return;
        } else {
          ApiErrorHandler.handleError(context, e);
        }
      }
    }
  }

  void _emailValidationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextView(
                  text: 'Account Verification Required',
                  fontColor: MyStyle.primaryLightColor,
                  alignment: Alignment.center,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your account has not been verified yet. To login, please follow these steps:',
                  style: TextStyle(fontSize: MyStyle.fourteen, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: MyStyle.fourteen, // Assuming MyStyle.fourteen is defined elsewhere
                      fontFamily: 'Poppins',
                      color: Colors.black, // Default text color
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '1. ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Check your email inbox for a verification link sent to your registered email address.\n'),
                      TextSpan(text: '2. ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "If you didn't receive the email, please check your spam folder.\n"),
                      TextSpan(text: '3. ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Click on the verification link to confirm your email address.\n'),
                      TextSpan(text: '4. ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Once verified, you will have full access to our platform.\n'),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: MyStyle.fourteen, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
