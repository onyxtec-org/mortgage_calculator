import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../common/constants/constants.dart';
import '../common/utils/shared_pref_helper.dart';
import '../common/utils/utils.dart';

class ApiErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    if (error is DioException) {
      handleDioError(context, error);
    } else {
      handleGenericError(error);
    }
  }

  static Future<void> handleDioError(BuildContext context, DioException error) async {
    if (error.response != null) {
      // DioError with response
      print('DioError: ${error.response!.statusCode}');
      print('Response data: ${error.response!.data}');
      Map<String, dynamic> responseData = error.response!.data;
      Utils.showToast('${responseData['message']}');
      if (responseData['message'] == "Your account has been blocked. For further details, please contact the admin") {
        goToLogInPage(context);
      }
      if (responseData['message'] == 'Unauthenticated.') {
        goToLogInPage(context);
      }
    } else {
      // DioError without response
      print('DioError: ${error.message}');
      Utils.showToast('${error.message}');
    }
  }

  static void handleGenericError(dynamic error) {
    print('Error: $error');
    Utils.showToast('Error: $error');
  }

  static void goToLogInPage(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context, listen: false);
    SharedPrefHelper.saveStringValues(Constants.authToken, null);
    SharedPrefHelper.saveStringValues(Constants.fcmToken, null);
    // provider.changeTabBarIndex(index: 0);
    // provider.logout();
  }
}
