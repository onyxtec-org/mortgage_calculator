import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

class MortgageLoanModel {
  final int? id;
  int? createdAt;
  int? updatedAt;
  double homePrice;
  double downPayment;
  double loanToValue;
  double propertyTax;
  double pmi;
  int loanTerm;
  double homeOwnerInsurance;
  double interestRate;
  double hoaFees;
  double? monthlyMortgage;

  MortgageLoanModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.homePrice,
    required this.downPayment,
    this.loanToValue,
    required this.propertyTax,
    required this.pmi,
    required this.loanTerm,
    required this.homeOwnerInsurance,
    required this.interestRate,
    required this.hoaFees,
    this.monthlyMortgage,
  });
}
