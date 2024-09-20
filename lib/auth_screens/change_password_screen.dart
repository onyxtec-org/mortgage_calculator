import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/network/api_error_handler.dart';

import '../common/constants/constants.dart';
import '../common/constants/icons_constant.dart';
import '../common/utils/shared_pref_helper.dart';
import '../common/utils/utils.dart';
import '../common/widgets/elevated_button.dart';
import '../common/widgets/navigation_bar.dart';
import '../common/widgets/password_text_field.dart';
import '../common/widgets/progress_dialog.dart';
import '../network/network_call_manager.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? _oldPassError;
  String? _newPassError;
  String? _confPassError;

  var _oldPassController = TextEditingController();
  var _newPassController = TextEditingController();
  var _confPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NavBar(
              backIcon: IconsConstant.icBackArrow,
              titleText: 'Change Password',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // old password field
                      Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                          child: Column(
                            children: [
                              PasswordTextField(
                                controller: _oldPassController,
                                inputType: TextInputType.visiblePassword,
                                hint: Constants.currentPassword,
                                inputAction: TextInputAction.next,
                                errorText: _oldPassError,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _oldPassError = 'Please enter old password';
                                    } else {
                                      _oldPassError = null;
                                    }
                                  });
                                },
                              ),
                              // new password field
                              PasswordTextField(
                                controller: _newPassController,
                                inputType: TextInputType.visiblePassword,
                                hint: Constants.newPassword,
                                inputAction: TextInputAction.next,
                                errorText: _newPassError,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _newPassError = 'Please enter New password';
                                    }
                                    /*(!Utils.passwordRegex.hasMatch(value)) {
                                      _newPassError = 'Please enter a valid new password';
                                    }*/
                                    else {
                                      _newPassError = null;
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
                                errorText: _confPassError,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _confPassError = 'Please enter confirm password';
                                    } else if (_confPassController.text != _newPassController.text) {
                                      _confPassError = 'Your confirm password is not matched';
                                    } else {
                                      _confPassError = null;
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                width: double.infinity,
                                child: Button(
                                    onPressed: () {
                                      validatePasswordAndChange(context);
                                    },
                                    text: "Change"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> validatePasswordAndChange(BuildContext context) async {
    String currentPassword = _oldPassController.text;
    String newPassword = _newPassController.text;
    String confirmPassword = _confPassController.text;
    setState(() {
      if (currentPassword.isEmpty) {
        _oldPassError = 'Please enter current password';
      }
      if (newPassword.isEmpty) {
        _newPassError = 'Please enter new password';
      } else if (newPassword.length < 8) {
        _newPassError = 'Your password must be greater or equal to 8 characters';
      }
      if (confirmPassword.isEmpty) {
        _confPassError = 'Please enter confirm password';
      }
      if (newPassword != confirmPassword) {
        _confPassError = 'Confirm password doesn\'t match';
      }
    });

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      return;
    }

    ProgressDialog.show(context, "Updating Password...");

    FormData body = FormData.fromMap({
      "current_password": currentPassword,
      "new_password": newPassword,
    });

    String? bearerToken = await SharedPrefHelper.retrieveStringValues(Constants.authToken);
    var header = NetworkCallManager().header;
    header['Authorization'] = 'Bearer $bearerToken';

    try {
      var response = await NetworkCallManager().apiCall(endPoint: ApiEndPoints.changePassword, body: body, header: header);
      ProgressDialog.hide(context);
      Navigator.of(context).pop();
      Map<String, dynamic> responseData = response;
      String message = responseData['message'];
      Utils.showToast('$message');
      saveData(password: newPassword);
    } on DioException catch (e) {
      ProgressDialog.hide(context);
      print('DioError: ${e.response!.statusCode}');
      ApiErrorHandler.handleError(context, e);
    }
  }

  Future<void> saveData({required String password}) async {
    bool isNotRemember = await SharedPrefHelper.retrieveBooleanValues(Constants.isNotRemember);
    if (!isNotRemember) {
      SharedPrefHelper.saveStringValues(Constants.rememberPassword, password);
    }
    _oldPassController.clear();
    _newPassController.clear();
    _confPassController.clear();
    Navigator.of(context);
  }
}
