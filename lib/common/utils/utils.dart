import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../constants/my_style.dart';

class Utils {
  static RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  static RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  static String formatTimestampToTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  static String formatDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('MM-dd-yyyy').format(date);
    return formattedDate;
  }

  static int getUnixTimeStamp() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: MyStyle.grayColor,
      textColor: MyStyle.whiteColor,
      fontSize: MyStyle.sixteen,
    );
  }
}
