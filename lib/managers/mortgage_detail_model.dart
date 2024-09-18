class MortgageDetailModel {
  int? type;
  String term;
  double monthlyMortgage;
  double principalPaid;
  double monthlyInterest;
  double remainingBalance;

  MortgageDetailModel({
    this.type,
    required this.term,
    required this.monthlyMortgage,
    required this.principalPaid,
    required this.monthlyInterest,
    required this.remainingBalance,
  });
}
