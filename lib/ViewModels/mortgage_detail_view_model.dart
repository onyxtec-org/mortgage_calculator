import 'package:flutter/material.dart';
import 'package:mortgage_calculator/managers/mortgage_detail_model.dart';
import 'package:mortgage_calculator/managers/mortgage_loan_manager.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';

class MortgageDetailViewModel extends ChangeNotifier {
  List<MortgageDetailModel> _data = [];

  List<MortgageDetailModel> get data => _data;

  void updateData(int type, MortgageLoanModel mortgageData) {
    if (type == 0) {
      _data = MortgageLoanManager.createMonthlyBreakdown(mortgageData: mortgageData);
    }else{
      _data = MortgageLoanManager.createAnnualBreakdown(mortgageData: mortgageData);
    }
    notifyListeners();
  }


}
