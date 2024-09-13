import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/navigation_bar.dart';
import 'package:mortgage_calculator/common/widgets/icon_text_view.dart';
import 'package:mortgage_calculator/common/widgets/text_input_container.dart';
import 'package:mortgage_calculator/common/widgets/text_input_field_widget.dart';
import 'package:mortgage_calculator/managers/mortgage_loan_manager.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';
import 'package:mortgage_calculator/result_screen.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'common/constants/constants.dart';
import 'common/widgets/alert_dialog.dart';

class CalculatorFormScreen extends StatefulWidget {
  const CalculatorFormScreen({super.key});

  @override
  State<CalculatorFormScreen> createState() => _CalculatorFormScreenState();
}

class _CalculatorFormScreenState extends State<CalculatorFormScreen> {
  String? _titleError;
  String? _homePriceError;
  String? _downPaymentError;
  String? _loanTermError;
  String? _interestRateError;
  String? _propertyTaxError;
  String? _pmiError;
  String? _homeOwnerInsuranceError;
  String? _hoaFeesError;

  final TextEditingController _titleTextFieldController = TextEditingController();
  final TextEditingController _homePriceTextFieldController = TextEditingController();
  final TextEditingController _downPaymentTextFieldController = TextEditingController();
  final TextEditingController _downPaymentPercentTextFieldController = TextEditingController();
  final TextEditingController _loanTermTextFieldController = TextEditingController();
  final TextEditingController _interestRateTextFieldController = TextEditingController();
  final TextEditingController _propertyTaxTextFieldController = TextEditingController();
  final TextEditingController _pmiTextFieldController = TextEditingController();
  final TextEditingController _homeOwnerInsTextFieldController = TextEditingController();
  final TextEditingController _hoaFeesTextFieldController = TextEditingController();

  MortgageLoanModel? model;

  double? homePrice, downPayment, loanToValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyStyle.primaryColor,
          width: double.infinity,
          child: Column(
            children: [
              NavBar(
                backIcon: IconsConstant.icBackArrow,
                iconsColor: MyStyle.whiteColor,
                titleText: Constants.mortgage,
                titleColor: MyStyle.whiteColor,
              ),
              const SizedBox(height: MyStyle.twenty),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(MyStyle.twenty),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(MyStyle.twentyFour),
                      topRight: Radius.circular(MyStyle.twentyFour),
                    ),
                    color: MyStyle.backgroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const IconTextView(
                          text: Constants.title,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: false,
                        ),
                        const SizedBox(height: MyStyle.four),
                        TextInputFieldWidget(
                          controller: _titleTextFieldController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          errorText: _titleError,
                          onChanged: (value) {
                            setState(() {
                              _titleError = value.isEmpty ? 'Please enter title' : null;
                            });
                          },
                        ),
                        IconTextView(
                          text: Constants.homePrice,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: true,
                          onTapIcon: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialogWidget(
                                    titleText: 'Home price',
                                    content: 'This is the amount you expect to pay for a home',
                                    pressedYes: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                          },
                        ),
                        const SizedBox(height: MyStyle.four),
                        TextInputFieldWidget(
                          controller: _homePriceTextFieldController,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          errorText: _homePriceError,
                          suffixText: '\$',
                          onChanged: (value) {
                            setState(() {
                              double? parsedValue = double.tryParse(value);
                              if (parsedValue != null && parsedValue > 0) {
                                homePrice = parsedValue;
                                _homePriceError = null;
                                calculateLoanToValue();
                              } else {
                                _homePriceError = value.isEmpty ? 'Please enter home price' : 'Home price must be positive';
                              }
                            });
                          },
                        ),

                        /* Down Payment views */
                        IconTextView(
                          text: Constants.downPayment,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: true,
                          onTapIcon: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialogWidget(
                                    titleText: 'Down payment',
                                    content: 'Portion of the sale price of a home that is not financed. Your down payment account can '
                                        'affect the interest rate you get, as lenders typically offer lower rates for borrowers who '
                                        'make larger down payment',
                                    pressedYes: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                          },
                        ),
                        const SizedBox(height: MyStyle.four),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextInputFieldWidget(
                                controller: _downPaymentTextFieldController,
                                inputType: TextInputType.number,
                                inputAction: TextInputAction.next,
                                errorText: _downPaymentError,
                                suffixText: '\$',
                                onChanged: (value) {
                                  setState(() {
                                    double? parsedValue = double.tryParse(value);
                                    if (parsedValue != null && parsedValue > 0) {
                                      downPayment = parsedValue;
                                      _downPaymentError = null;
                                      calculateLoanToValue();
                                    } else {
                                      _downPaymentError = value.isEmpty ? 'Please enter down payment' : 'Down payment must be positive';
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextInputContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: IconTextView(
                                            text: loanToValue == null ? '' : loanToValue!.toStringAsFixed(2),
                                            color: MyStyle.primaryColor,
                                            fontSize: MyStyle.fourteen)),
                                    const IconTextView(text: '%', color: MyStyle.grayColor, fontSize: MyStyle.fourteen),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        /* Loan Term view */
                        IconTextView(
                          text: Constants.loanTerm,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: false,
                          onTapIcon: () {},
                        ),
                        const SizedBox(height: MyStyle.four),
                        TextInputFieldWidget(
                          controller: _loanTermTextFieldController,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          errorText: _loanTermError,
                          suffixText: 'years',
                          onChanged: (value) {
                            setState(() {
                              int? parsedValue = int.tryParse(value);
                              if (parsedValue != null && parsedValue > 0) {
                                _loanTermError = null;
                              } else {
                                _loanTermError = value.isEmpty ? 'Please enter loan term' : 'Loan term must be positive';
                              }
                            });
                          },
                        ),

                        /* Interest Rate view */
                        IconTextView(
                          text: Constants.interestRate,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: false,
                          onTapIcon: () {},
                        ),
                        const SizedBox(height: MyStyle.four),
                        TextInputFieldWidget(
                          controller: _interestRateTextFieldController,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          errorText: _interestRateError,
                          suffixText: '%',
                          onChanged: (value) {
                            setState(() {
                              double? parsedValue = double.tryParse(value);
                              if (parsedValue != null && parsedValue > 0) {
                                _interestRateError = null;
                              } else {
                                _interestRateError = value.isEmpty ? 'Please enter interest rate' : 'Interest rate must be positive';
                              }
                            });
                          },
                        ),

                        /* Property tax and PMI view */
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const IconTextView(
                                    text: Constants.propertyTax,
                                    color: MyStyle.primaryColor,
                                    fontSize: MyStyle.fourteen,
                                  ),
                                  const SizedBox(height: MyStyle.four),
                                  TextInputFieldWidget(
                                    controller: _propertyTaxTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _propertyTaxError,
                                    suffixText: '\$',
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          _propertyTaxError = null;
                                        } else {
                                          _propertyTaxError = value.isEmpty ? 'Please enter property tax' : 'Property tax must be positive';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: MyStyle.ten),
                            Expanded(
                              child: Column(
                                children: [
                                  const IconTextView(
                                    text: Constants.pmi,
                                    color: MyStyle.primaryColor,
                                    fontSize: MyStyle.fourteen,
                                  ),
                                  const SizedBox(height: MyStyle.four),
                                  TextInputFieldWidget(
                                    controller: _pmiTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _pmiError,
                                    suffixText: '\$',
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          _pmiError = null;
                                        } else {
                                          _pmiError = value.isEmpty ? 'Please enter PMI' : 'PIM must be positive';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /* Home owner insurance and HOA fees views */
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const IconTextView(
                                    text: Constants.homeOwnerInsurance,
                                    color: MyStyle.primaryColor,
                                    fontSize: MyStyle.fourteen,
                                  ),
                                  const SizedBox(height: MyStyle.four),
                                  TextInputFieldWidget(
                                    controller: _homeOwnerInsTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _homeOwnerInsuranceError,
                                    suffixText: '\$',
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          _homeOwnerInsuranceError = null;
                                        } else {
                                          _homeOwnerInsuranceError = value.isEmpty
                                              ? 'Please enter home owner insurance'
                                              : 'Home owner '
                                                  'insurance must be positive';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: MyStyle.ten),
                            Expanded(
                              child: Column(
                                children: [
                                  const IconTextView(
                                    text: Constants.hoaFees,
                                    color: MyStyle.primaryColor,
                                    fontSize: MyStyle.fourteen,
                                  ),
                                  const SizedBox(height: MyStyle.four),
                                  TextInputFieldWidget(
                                    controller: _hoaFeesTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.done,
                                    errorText: _hoaFeesError,
                                    suffixText: '\$',
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          _hoaFeesError = null;
                                        } else {
                                          _hoaFeesError = value.isEmpty ? 'Please enter HOA fees' : 'HOA fees must be positive';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: MyStyle.twenty),
                        /* Calculate button */
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                              onPressed: () {
                                validateData();
                              },
                              text: Constants.calculate),
                        ),
                        const SizedBox(height: MyStyle.twenty),

                        /* Reset fields button */
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                            onPressed: () {
                              resetFields();
                            },
                            text: Constants.resetFields,
                            buttonColor: MyStyle.whiteColor,
                            textColor: MyStyle.primaryColor,
                            hasBorder: true,
                          ),
                        ),
                        const SizedBox(height: MyStyle.twenty),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateData() {
    final fieldValidations = {
      _titleTextFieldController: 'Enter title',
      _homePriceTextFieldController: 'Home price must be positive',
      _downPaymentTextFieldController: 'Down payment must be positive',
      _loanTermTextFieldController: 'Loan term must be positive',
      _interestRateTextFieldController: 'Interest rate must be positive',
      _propertyTaxTextFieldController: 'Property tax must be positive',
      _pmiTextFieldController: 'PMI must be positive',
      _homeOwnerInsTextFieldController: 'Home owner insurance must be positive',
      _hoaFeesTextFieldController: 'HOA fees must be positive',
    };

    bool allValid = true;

    fieldValidations.forEach((controller, positiveErrorMessage) {
      final isEmpty = controller.text.isEmpty;
      final value = double.tryParse(controller.text);

      setState(() {
        String? errorMessage;
        if (isEmpty) {
          errorMessage = controller == _titleTextFieldController ? 'Please enter title' : 'Please enter a value';
        } else if (value == null || value <= 0) {
          errorMessage = controller == _titleTextFieldController ? null : positiveErrorMessage;
        }

        // Update the corresponding error variable dynamically
        final errorVariable = _getErrorVariable(controller);
        errorVariable?.call(errorMessage);
      });
      if (controller == _titleTextFieldController && !isEmpty) {
        allValid = true;
      } else if (isEmpty || value == null || value <= 0) {
        allValid = false;
        print('invalid');
      }
    });

    if (allValid) {
      // All inputs are valid, proceed
      MortgageLoanModel updatedModel = MortgageLoanModel(
        homePrice: double.parse(_homePriceTextFieldController.text),
        downPayment: double.parse(_downPaymentTextFieldController.text),
        loanTerm: int.parse(_loanTermTextFieldController.text),
        // in years
        interestRate: double.parse(_interestRateTextFieldController.text),
        // in percent
        propertyTax: double.parse(_propertyTaxTextFieldController.text),
        pmi: double.parse(_pmiTextFieldController.text),
        homeOwnerInsurance: double.parse(_homeOwnerInsTextFieldController.text),
        hoaFees: double.parse(_hoaFeesTextFieldController.text),
        title: _titleTextFieldController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mortgageLoanModel: updatedModel,
            isHistory: false,
          ),
        ),
      );
      print('Input fields data $updatedModel');
    }
  }

  Function(String?)? _getErrorVariable(TextEditingController controller) {
    if (controller == _titleTextFieldController) return (String? error) => _titleError = error;
    if (controller == _homePriceTextFieldController) return (String? error) => _homePriceError = error;
    if (controller == _downPaymentTextFieldController) return (String? error) => _downPaymentError = error;
    if (controller == _loanTermTextFieldController) return (String? error) => _loanTermError = error;
    if (controller == _interestRateTextFieldController) return (String? error) => _interestRateError = error;
    if (controller == _propertyTaxTextFieldController) return (String? error) => _propertyTaxError = error;
    if (controller == _pmiTextFieldController) return (String? error) => _pmiError = error;
    if (controller == _homeOwnerInsTextFieldController) return (String? error) => _homeOwnerInsuranceError = error;
    if (controller == _hoaFeesTextFieldController) return (String? error) => _hoaFeesError = error;
    return null;
  }

  void calculateLoanToValue() {
    if (homePrice != null && downPayment != null) {
      setState(() {
        loanToValue = MortgageLoanManager.calculateDownPaymentPercentage(homePrice!, downPayment!);
        _downPaymentPercentTextFieldController.text = loanToValue!.toStringAsFixed(2);
      });
    }
  }

  void resetFields() {
    // Clear text from all controllers
    _titleTextFieldController.clear();
    _homePriceTextFieldController.clear();
    _downPaymentTextFieldController.clear();
    _downPaymentPercentTextFieldController.clear();
    _loanTermTextFieldController.clear();
    _interestRateTextFieldController.clear();
    _propertyTaxTextFieldController.clear();
    _pmiTextFieldController.clear();
    _homeOwnerInsTextFieldController.clear();
    _hoaFeesTextFieldController.clear();

    // Reset all error messages
    setState(() {
      _titleError = null;
      _homePriceError = null;
      _downPaymentError = null;
      _loanTermError = null;
      _interestRateError = null;
      _propertyTaxError = null;
      _pmiError = null;
      _homeOwnerInsuranceError = null;
      _hoaFeesError = null;
    });
  }
}
