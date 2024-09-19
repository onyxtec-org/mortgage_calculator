import 'package:intl/intl.dart';

class Utils{

  static String formatTimestampToTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  static String formatTimeStampToDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('MM-dd-yyyy').format(date);
    return formattedDate;
  } 
  static String formatDate(DateTime date) {
    var formattedDate = DateFormat('MM-dd-yyyy').format(date);
    return formattedDate;
  }

  static int getUnixTimeStamp() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  static String formatCurrency(double amount) {
    String currencyNumber = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
    return currencyNumber;
  }

}