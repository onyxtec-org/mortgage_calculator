import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  bool _isUpdated = false;

  bool get isUpdate => _isUpdated;

  void updateProvider({required bool updateStatus}) {
    _isUpdated = updateStatus;
    notifyListeners();
  }
}
