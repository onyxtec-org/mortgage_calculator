class MortgageLoanModel {
  final int? id;
  double homePrice;
  double propertyTax;
  double downPayment;
  double pmi;
  int loanTerm;
  double homeOwnerInsurance;
  double interestRate;
  double hoaFees;

  MortgageLoanModel({
    this.id,
    required this.homePrice,
    required this.propertyTax,
    required this.downPayment,
    required this.pmi,
    required this.loanTerm,
    required this.homeOwnerInsurance,
    required this.interestRate,
    required this.hoaFees,
  });
}
