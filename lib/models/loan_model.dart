class LoanModel {
  final int? id;
  double howePrice;
  double propertyTax;
  double downPayment;
  double pmi;
  int loanTerm;
  double homeOwnerInsurance;
  double interestRate;
  double hoaFees;

  LoanModel({
    this.id,
    required this.howePrice,
    required this.propertyTax,
    required this.downPayment,
    required this.pmi,
    required this.loanTerm,
    required this.homeOwnerInsurance,
    required this.interestRate,
    required this.hoaFees,
  });
}
