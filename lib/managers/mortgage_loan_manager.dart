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
    return (annualInterestRate / 100) /*/ 12*/;
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
    return (pmiRate / 100 * loanAmount) /*/ 12*/;
  }

  // Convert PMI amount to percentage
  static double convertPMIAmountToPercentage(double pmiAmount, double loanAmount) {
    return (pmiAmount / loanAmount) * 100;
  }

  // Calculate the Loan-to-Value (LTV) ratio
  static double calculateLTV(double homePrice, double downPayment) {
    double loanAmount = calculateLoanAmount(homePrice, downPayment);
    return (loanAmount / homePrice) * 100;
  }

  // Calculate Down Payment as a percentage of the home price
  static double calculateDownPaymentPercentage(double homePrice, double downPayment) {
    // Check if down payment is greater than home price
    if (downPayment > homePrice) {
      // Optionally, you can handle this case differently, like returning a specific value or throwing an error
      return double.nan; // or return a value that indicates invalid input
    }
    return (downPayment / homePrice) * 100;
  }

  // Calculate the total monthly payment including mortgage, taxes, insurance, and fees
  static Result calculateTotalMonthlyPayment({
    required double homePrice,
    required double downPayment,
    required int loanTermYears,
    required double annualInterestRate,
    required double annualPropertyTax, // This is now the total annual property tax amount
    required double annualHomeInsurance,
    required double pmiAmount, // PMI amount in dollars
    required double hoaFees,
  }) {
    double loanAmount = calculateLoanAmount(homePrice, downPayment);
    double monthlyInterestRate = calculateMonthlyInterestRate(annualInterestRate);
    int numberOfPayments = calculateNumberOfPayments(loanTermYears);
    double monthlyMortgage = calculateMonthlyMortgagePayment(loanAmount, monthlyInterestRate, numberOfPayments);
    double monthlyPropertyTax = calculateMonthlyPropertyTax(annualPropertyTax);
    double pmiRate = convertPMIAmountToPercentage(pmiAmount, loanAmount); // Convert PMI amount to percentage
    double monthlyPMI = calculateMonthlyPMI(loanAmount, pmiRate);
    double monthlyHOInsurance = annualHomeInsurance / 12;

    // Log values for debugging
    print('loanAmount: $loanAmount');
    print('monthlyInterestRate: $monthlyInterestRate');
    print('numberOfPayments: $numberOfPayments');
    print('monthlyMortgage: $monthlyMortgage');
    print('monthlyPropertyTax: $monthlyPropertyTax');
    print('monthlyPMI: $monthlyPMI');
    print('monthlyHomeOwnerInsurance: $monthlyHOInsurance');

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
    // Calculate the total monthly payment
    var totalMonthlyPayment = monthlyMortgage + monthlyPropertyTax + monthlyHOInsurance + hoaFees; // will add this if require "monthlyPMI"
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

    // Initialize remaining loan balance
    double remainingBalance = loanAmount;

    List<MortgageDetailModel> monthlyBreakdown = [];

    // Get the current date
    DateTime currentDate = DateTime.now();

    for (int month = 0; month <= numberOfPayments; month++) {
      // Calculate interest for the current month
      double monthlyInterest = remainingBalance * monthlyInterestRate;

      // Calculate principal paid for the current month
      double principalPaid = monthlyMortgage - monthlyInterest;

      // Subtract the principal from the remaining balance
      remainingBalance -= principalPaid;

      // Calculate the actual month and year for this payment
      DateTime paymentDate = DateTime(currentDate.year, currentDate.month + month);
      String monthName = DateFormat.yMMM().format(paymentDate); // Format to show month and year

      MortgageDetailModel monthlyData = MortgageDetailModel(
        type: 0,
        term: monthName,
        monthlyMortgage: monthlyMortgage,
        principalPaid: principalPaid,
        monthlyInterest: monthlyInterest,
        remainingBalance: remainingBalance,
      );
      monthlyBreakdown.add(monthlyData);
      // Add the monthly breakdown to the list
      /* monthlyBreakdown.add({
        'Month': month,
        'Monthly Mortgage': monthlyMortgage,
        'Principal Paid': principalPaid,
        'Interest Paid': monthlyInterest,
        'Remaining Balance': remainingBalance,
        'Property Tax': monthlyPropertyTax,
        'PMI': monthlyPMI,
        'Home Insurance': monthlyHomeInsurance,
        'HOA Fees': hoaFees,
        'Total Monthly Payment': monthlyMortgage + monthlyPropertyTax + monthlyPMI + monthlyHomeInsurance + hoaFees,
      });*/
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

    // Initialize remaining loan balance
    double remainingBalance = loanAmount;

    // Initialize the annual breakdown list
    List<MortgageDetailModel> annualBreakdown = [];

    // Get the current year
    int currentYear = DateTime.now().year;

    // Summarize data year by year
    for (int year = 0; year < mortgageData.loanTerm; year++) {
      // Initialize totals for the year
      double totalMortgage = 0;
      double totalPrincipalPaid = 0;
      double totalInterestPaid = 0;
      double totalPropertyTax = 0;
      double totalPMI = 0;
      double totalHomeInsurance = 0;
      double totalHOAFees = 0;

      // Loop through 12 months of the year
      for (int month = 0; month < 12; month++) {
        if (year * 12 + month > numberOfPayments) break; // Stop if we've reached the end of payments

        // Calculate interest and principal for the current month
        double monthlyInterest = remainingBalance * monthlyInterestRate;
        double principalPaid = monthlyMortgage - monthlyInterest;

        // Subtract the principal from the remaining balance
        remainingBalance -= principalPaid;

        // Add the monthly totals to the yearly totals
        totalMortgage += monthlyMortgage;
        totalPrincipalPaid += principalPaid;
        totalInterestPaid += monthlyInterest;
        totalPropertyTax += monthlyPropertyTax;
        totalPMI += monthlyPMI;
        totalHomeInsurance += monthlyHomeInsurance;
        totalHOAFees += mortgageData.hoaFees;
      }

      MortgageDetailModel monthlyData = MortgageDetailModel(
        type: 1,
        term: (currentYear + year).toString(),
        monthlyMortgage: totalMortgage,
        principalPaid: totalPrincipalPaid,
        monthlyInterest: totalInterestPaid,
        remainingBalance: remainingBalance,
      );
      annualBreakdown.add(monthlyData);
      // Add the yearly breakdown to the list
/*      annualBreakdown.add({
        'Year': year,
        'Total Mortgage Payment': totalMortgage,
        'Total Principal Paid': totalPrincipalPaid,
        'Total Interest Paid': totalInterestPaid,
        'Remaining Balance': remainingBalance,
        'Total Property Tax': totalPropertyTax,
        'Total PMI': totalPMI,
        'Total Home Insurance': totalHomeInsurance,
        'Total HOA Fees': totalHOAFees,
        'Total Annual Payment': totalMortgage + totalPropertyTax + totalPMI + totalHomeInsurance + totalHOAFees,
      });*/
    }

    return annualBreakdown;
  }
}
