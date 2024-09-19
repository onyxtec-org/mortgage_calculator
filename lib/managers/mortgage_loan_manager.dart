import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mortgage_calculator/managers/calculation.dart';
import 'package:mortgage_calculator/managers/mortgage_detail_model.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';

import 'result.dart';

class MortgageLoanManager {
  // Calculate loan amount by subtracting the down payment from the home price
  static double calculateLoanAmount(double homePrice, double downPayment) {
    return homePrice - downPayment;
  }

  // Calculate the monthly interest rate from the annual interest rate (which is a percentage)
  static double calculateMonthlyInterestRate(double annualInterestRate) {
    return (annualInterestRate / 100) / 12;
  }

  // Calculate the number of payments over the loan term (loan term in years)
  static int calculateNumberOfPayments(int loanTermYears) {
    return loanTermYears * 12;
  }

  // Calculate the monthly mortgage payment using the loan amount, monthly interest rate, and number of payments
  static double calculateMonthlyMortgagePayment(double loanAmount, double monthlyInterestRate, int numberOfPayments) {
    return loanAmount *
        (monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfPayments)) /
        (pow(1 + monthlyInterestRate, numberOfPayments) - 1);
  }

  // Calculate monthly property tax based on annual property tax amount
  static double calculateMonthlyPropertyTax(double annualPropertyTax) {
    return annualPropertyTax / 12;
  }

  // Calculate monthly PMI (private mortgage insurance) based on the loan amount and PMI rate (as a percentage)
  static double calculateMonthlyPMI(double loanAmount, double pmiRate) {
    return (pmiRate / 100 * loanAmount);
  }

  // Convert PMI amount to percentage
  static double convertPMIAmountToPercentage(double annualPMIAmount, double loanAmount) {
    return (annualPMIAmount / loanAmount) * 100;
  }

  // Calculate the Loan-to-Value (LTV) ratio
  static double calculateLTV(double homePrice, double downPayment) {
    double loanAmount = calculateLoanAmount(homePrice, downPayment);
    return (loanAmount / homePrice) * 100;
  }

  // Calculate Down Payment as a percentage of the home price
  static double calculateDownPaymentPercentage(double homePrice, double downPayment) {
    if (downPayment > homePrice) {
      // Optionally, you can handle this case differently, like returning a specific value or throwing an error
      return double.nan; // or return a value that indicates invalid input
    }
    return (downPayment / homePrice) * 100;
  }

  static double calculateDownPaymentValue(double homePrice, double percentage) {
    if (percentage < 0 || percentage > 100) {
      // Handle invalid percentage
      throw ArgumentError('Percentage must be between 0 and 100.');
    }
    return (percentage / 100) * homePrice;
  }

  static String formatCurrency(double amount) {
    String currencyNumber = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
    return currencyNumber;
  }

  // Calculate the total monthly payment including mortgage, taxes, insurance, and fees
  static Result calculateTotalMonthlyPayment({
    required double homePrice,
    required double downPayment,
    required int loanTermYears,
    required double annualInterestRate,
    required double annualPropertyTax,
    required double annualHomeInsurance,
    required double annualPMIAmount,
    required double hoaFees,
  }) {
    double loanAmount = calculateLoanAmount(homePrice, downPayment);
    double monthlyInterestRate = calculateMonthlyInterestRate(annualInterestRate);
    int numberOfPayments = calculateNumberOfPayments(loanTermYears);
    double monthlyMortgage = calculateMonthlyMortgagePayment(loanAmount, monthlyInterestRate, numberOfPayments);
    double monthlyPropertyTax = calculateMonthlyPropertyTax(annualPropertyTax);
    double pmiRate = convertPMIAmountToPercentage(annualPMIAmount, loanAmount); // Convert PMI amount to percentage
    double monthlyPMI = calculateMonthlyPMI(loanAmount, pmiRate);
    double monthlyHOInsurance = annualHomeInsurance / 12;

    final calculation = Calculation(
      termType: 0,
      interestRate: monthlyInterestRate,
      numberOfPayments: numberOfPayments,
      mortgage: monthlyMortgage,
      propertyTax: monthlyPropertyTax,
      PMI: monthlyPMI,
      houseOwnerInsurance: monthlyHOInsurance,
      haoFees: hoaFees,
    );

    var totalMonthlyPayment = monthlyMortgage + monthlyPropertyTax + monthlyHOInsurance + hoaFees + monthlyPMI;

    Result result = Result(
      principleAndInterest: monthlyMortgage,
      totalMonthlyPayment: totalMonthlyPayment,
      details: calculation,
    );
    return result;
  }

  // Function to create a monthly breakdown
  static List<MortgageDetailModel> createMonthlyBreakdown({
    required MortgageLoanModel mortgageData,
  }) {
    double loanAmount = calculateLoanAmount(mortgageData.homePrice, mortgageData.downPayment);
    double monthlyInterestRate = calculateMonthlyInterestRate(mortgageData.interestRate);
    int numberOfPayments = calculateNumberOfPayments(mortgageData.loanTerm);
    double monthlyMortgage = calculateMonthlyMortgagePayment(loanAmount, monthlyInterestRate, numberOfPayments);
    double monthlyPropertyTax = calculateMonthlyPropertyTax(mortgageData.propertyTax);
    double pmiRate = (mortgageData.pmi / loanAmount) * 100;
    double monthlyPMI = calculateMonthlyPMI(loanAmount, pmiRate);
    double monthlyHomeInsurance = mortgageData.annualHomeOwnerInsurance / 12;

    double remainingBalance = loanAmount;
    List<MortgageDetailModel> monthlyBreakdown = [];
    DateTime currentDate = DateTime.now();

    for (int month = 0; month < numberOfPayments; month++) {
      double monthlyInterest = remainingBalance * monthlyInterestRate;
      double principalPaid = monthlyMortgage - monthlyInterest;
      remainingBalance -= principalPaid;

      if (remainingBalance < 1) {
        remainingBalance = 0.00;
      }

      DateTime paymentDate = DateTime(currentDate.year, currentDate.month).add(Duration(days: month * 30));
      String monthName = DateFormat.yMMM().format(paymentDate);

      MortgageDetailModel monthlyData = MortgageDetailModel(
        type: 0,
        term: monthName,
        monthlyMortgage: monthlyMortgage,
        principalPaid: principalPaid,
        monthlyInterest: monthlyInterest,
        remainingBalance: remainingBalance,
      );
      monthlyBreakdown.add(monthlyData);
    }

    return monthlyBreakdown;
  }

  // Function to calculate annual payments
  static List<MortgageDetailModel> createAnnualBreakdown({
    required MortgageLoanModel mortgageData,
  }) {
    double loanAmount = calculateLoanAmount(mortgageData.homePrice, mortgageData.downPayment);
    double monthlyInterestRate = calculateMonthlyInterestRate(mortgageData.interestRate);
    int numberOfPayments = calculateNumberOfPayments(mortgageData.loanTerm);
    double monthlyMortgage = calculateMonthlyMortgagePayment(loanAmount, monthlyInterestRate, numberOfPayments);
    double monthlyPropertyTax = calculateMonthlyPropertyTax(mortgageData.propertyTax);
    double pmiRate = (mortgageData.pmi / loanAmount) * 100;
    double monthlyPMI = calculateMonthlyPMI(loanAmount, pmiRate);
    double monthlyHomeInsurance = mortgageData.annualHomeOwnerInsurance / 12;

    double remainingBalance = loanAmount;
    List<MortgageDetailModel> annualBreakdown = [];
    int currentYear = DateTime.now().year;

    for (int year = 0; year < mortgageData.loanTerm; year++) {
      if (year * 12 >= numberOfPayments) break;

      double totalMortgage = 0;
      double totalPrincipalPaid = 0;
      double totalInterestPaid = 0;
      double totalPropertyTax = 0;
      double totalPMI = 0;
      double totalHomeInsurance = 0;
      double totalHOAFees = 0;

      for (int month = 0; month < 12; month++) {
        if (year * 12 + month >= numberOfPayments) break;

        double monthlyInterest = remainingBalance * monthlyInterestRate;
        double principalPaid = monthlyMortgage - monthlyInterest;
        remainingBalance -= principalPaid;

        totalMortgage += monthlyMortgage;
        totalPrincipalPaid += principalPaid;
        totalInterestPaid += monthlyInterest;
        totalPropertyTax += monthlyPropertyTax;
        totalPMI += monthlyPMI;
        totalHomeInsurance += monthlyHomeInsurance;
        totalHOAFees += mortgageData.hoaFees;
      }

      if (remainingBalance < 1) {
        remainingBalance = 0.00;
      }

      MortgageDetailModel annualData = MortgageDetailModel(
        type: 1,
        term: (currentYear + year).toString(),
        monthlyMortgage: totalMortgage,
        principalPaid: totalPrincipalPaid,
        monthlyInterest: totalInterestPaid,
        remainingBalance: remainingBalance,
      );
      annualBreakdown.add(annualData);
    }

    return annualBreakdown;
  }
}
