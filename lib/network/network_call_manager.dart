import 'package:dio/dio.dart';

import 'api_constants.dart';

enum RequestType { GET, POST, UPDATE, PUT, PATCH, DELETE }

enum ApiEndPoints {
  signup,
  signin,
  logout,
  forgotPassword,
  deleteUser,
  changePassword,
}

extension ApiEndPointsValue on ApiEndPoints {
  String get url {
    switch (this) {
      case ApiEndPoints.signup:
        return ApiConstants.signup;
      case ApiEndPoints.signin:
        return ApiConstants.signin;
      case ApiEndPoints.deleteUser:
        return ApiConstants.deleteUser;
      case ApiEndPoints.logout:
        return ApiConstants.logout;
      case ApiEndPoints.forgotPassword:
        return ApiConstants.forgotPassword;
      case ApiEndPoints.changePassword:
        return ApiConstants.changePassword;
    }
  }

  RequestType get requestType {
    switch (this) {
      case ApiEndPoints.signup:
        return RequestType.POST;
        case ApiEndPoints.signin:
        return RequestType.POST;
      case ApiEndPoints.deleteUser:
        return RequestType.POST;
      case ApiEndPoints.logout:
        return RequestType.POST;
      case ApiEndPoints.forgotPassword:
        return RequestType.POST;
      case ApiEndPoints.changePassword:
        return RequestType.POST;
    }
  }
}

class NetworkCallManager {
  final dio = createDio();

  NetworkCallManager._internal(); //private constructor

  static final _singleton = NetworkCallManager._internal();

  factory NetworkCallManager() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveTimeout: const Duration(seconds: 60), // 20 seconds
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ));
    return dio;
  }

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> apiCall(
      {required ApiEndPoints endPoint, Map<String, dynamic>? queryParameters, FormData? body, Map<String, String>? header}) async {
    var result;
    try {
      var options = Options(headers: header ?? NetworkCallManager().header);
      switch (endPoint.requestType) {
        case RequestType.GET:
          {
            result = await dio.get(endPoint.url, queryParameters: queryParameters, options: options);
            break;
          }
        case RequestType.POST:
          {
            result = await dio.post(endPoint.url, data: body, options: options);
            break;
          }
        case RequestType.DELETE:
          {
            result = await dio.delete(endPoint.url, data: queryParameters, options: options);
            break;
          }
        case RequestType.UPDATE:
        // TODO: Handle this case.
        case RequestType.PUT:
        // TODO: Handle this case.
        case RequestType.PATCH:
        // TODO: Handle this case.
      }
      if (result != null) {
        return result.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw e; // Rethrow for caller to handle
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      throw error; // Rethrow for caller to handle
    } finally {
      // Perform any cleanup actions here (optional)
    }
  }
}
