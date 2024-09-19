class MortgageLoanModel {
  final int? id;
  int? createdAt;
  int? updatedAt;
  int? startedAt;
  String title;
  double homePrice;
  double downPayment;
  double? loanToValue;
  double propertyTax;
  double pmi;
  int loanTerm;
  double annualHomeOwnerInsurance;
  double interestRate;
  double hoaFees;
  double? monthlyMortgage;

  MortgageLoanModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.startedAt,
    required this.title,
    required this.homePrice,
    required this.downPayment,
    this.loanToValue,
    required this.propertyTax,
    required this.pmi,
    required this.loanTerm,
    required this.annualHomeOwnerInsurance,
    required this.interestRate,
    required this.hoaFees,
    this.monthlyMortgage,
  });

  /// Convert a MortgageLoanModel instance into a JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'startedAt': startedAt,
        'title': title,
        'homePrice': homePrice,
        'downPayment': downPayment,
        'propertyTax': propertyTax,
        'pmi': pmi, //Private Mortgage Insurance
        'loanTerm': loanTerm,
        'homeOwnerInsurance': annualHomeOwnerInsurance,
        'interestRate': interestRate,
        'hoaFees': hoaFees,
        'monthlyMortgage': monthlyMortgage, //Principle & interest
      };

  /// Create a MortgageLoanModel instance from a JSON map
  factory MortgageLoanModel.fromJson(Map<String, dynamic> json) {
    return MortgageLoanModel(
      id: json['id'] as int?,
      createdAt: json['createdAt'] as int?,
      updatedAt: json['updatedAt'] as int?,
      startedAt: json['startedAt'] as int?,
      title: json['title'] as String,
      homePrice: json['homePrice'] as double,
      downPayment: json['downPayment'] as double,
      loanToValue: json['loanToValue'] != null ? json['loanToValue'] as double : null,
      propertyTax: json['propertyTax'] as double,
      pmi: json['pmi'] as double,
      loanTerm: json['loanTerm'] as int,
      annualHomeOwnerInsurance: json['homeOwnerInsurance'] as double,
      interestRate: json['interestRate'] as double,
      hoaFees: json['hoaFees'] as double,
      monthlyMortgage: json['monthlyMortgage'] != null ? json['monthlyMortgage'] as double : null,
    );
  }
}
