import 'dart:math';

import 'package:mortgage_calculator/managers/calculation.dart';

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
    required double monthlyHomeOwnerInsurance,
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
    double monthlyHOInsurance = monthlyHomeOwnerInsurance;

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

  // Function to calculate annual payments
  static void calculateAnnualPayments({
    required double monthlyMortgage,
    required double monthlyPropertyTax,
    required double monthlyPMI,
    required double monthlyHOInsurance,
    required double hoaFees, // Assuming HOA fees are monthly as well
  }) {
    double annualMortgage = monthlyMortgage * 12;
    double annualPropertyTax = monthlyPropertyTax * 12;
    double annualPMI = monthlyPMI * 12;
    double annualHomeInsurance = monthlyHOInsurance * 12;
    double annualHOAFees = hoaFees * 12;

    // Print values for debugging
    print('Annual Mortgage Payment: \$${annualMortgage.toStringAsFixed(2)}');
    print('Annual Property Tax: \$${annualPropertyTax.toStringAsFixed(2)}');
    print('Annual PMI: \$${annualPMI.toStringAsFixed(2)}');
    print('Annual Homeowner\'s Insurance: \$${annualHomeInsurance.toStringAsFixed(2)}');
    print('Annual HOA Fees: \$${annualHOAFees.toStringAsFixed(2)}');

    final calculation = Calculation(
      termType: 1,
      mortgage: annualMortgage,
      propertyTax: annualPropertyTax,
      PMI: annualPMI,
      houseOwnerInsurance: annualHomeInsurance,
      haoFees: annualHOAFees,
    );
    double totalAnnualPayment = annualMortgage + annualPropertyTax + annualPMI + annualHomeInsurance + annualHOAFees;
    print('Total Annual Payment: \$${totalAnnualPayment.toStringAsFixed(2)}');
  }
}
