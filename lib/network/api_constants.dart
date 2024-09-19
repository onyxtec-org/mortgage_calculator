class ApiConstants {
  static const bool isProd = false;
  static const String devLink = 'https://0893-210-56-23-198.ngrok-free.app';
  static const String baseUrl = isProd ? 'https://domain/api/' : '${devLink}/api/';
  static const quoteImageBaseUrl =isProd ? 'https://jdt.onyxtec.io/images/quote/':'${devLink}/images/quote/';
  static const userImageBaseUrl = isProd ? 'https://jdt.onyxtec.io/images/user/': '${devLink}/images/user/';
  static const pdfBaseUrl = isProd ? 'https://jdt.onyxtec.io/storage/pdf/JDTrucking_quote_': '${devLink}/storage/pdf/JDTrucking_quote_';
  static const String signin = 'signin';
  static const String signup = 'signup';
  static const String forgotPassword = 'password/email';
  static const String register = "register";
  static const String quote = "quote";
  static const String logout = "logout";
  static const String deleteUser = "delete";
  static const String fetchMaterielList = 'quote/create';
  static const String placeQuote = 'quote/store';
  static const String profile = 'profile';
  static const String updateProfile = 'profile/store';
  static const String passwordReset = "password/reset";

}
