class Calculation {
  int termType;
  double? interestRate;
  int? numberOfPayments;
  double mortgage;
  double propertyTax;
  double PMI;
  double houseOwnerInsurance;
  double? haoFees;

  Calculation({
    required this.termType,
     this.interestRate,
    this.numberOfPayments,
    required this.mortgage,
    required this.propertyTax,
    required this.PMI,
    required this.houseOwnerInsurance,
    this.haoFees,
  });
}
