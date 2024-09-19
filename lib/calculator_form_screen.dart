import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/ink_well_widget.dart';
import 'package:mortgage_calculator/common/widgets/navigation_bar.dart';
import 'package:mortgage_calculator/common/widgets/icon_text_view.dart';
import 'package:mortgage_calculator/common/widgets/svg_icon_widget.dart';
import 'package:mortgage_calculator/common/widgets/text_input_container.dart';
import 'package:mortgage_calculator/common/widgets/text_input_field_widget.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import 'package:mortgage_calculator/managers/mortgage_loan_manager.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';
import 'package:mortgage_calculator/result_screen.dart';

import 'common/constants/constants.dart';
import 'common/utils/utils.dart';
import 'common/widgets/alert_dialog.dart';
import 'common/widgets/selectable_text_widget.dart';

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
  final TextEditingController _loanTermTextFieldController = TextEditingController();
  final TextEditingController _interestRateTextFieldController = TextEditingController();
  final TextEditingController _propertyTaxTextFieldController = TextEditingController();
  final TextEditingController _pmiTextFieldController = TextEditingController();
  final TextEditingController _homeOwnerInsTextFieldController = TextEditingController();
  final TextEditingController _hoaFeesTextFieldController = TextEditingController();

  MortgageLoanModel? model;

  double homePrice = 0;
  double propertyTax = 0;
  double downPayment = 0;
  double pmiPerYear = 0;
  double homeOwnerInsurance = 0;
  double? haoFeePerMonth;
  int loanTerm = 0;
  var isDPPercentageSelected = true;
  var isLoanTermYearSelected = true;
  var isPropertyTaxPercentageSelected = true;
  var isPMIPercentageSelected = true;
  var isHOwnerPercentageSelected = true;

  int? _selectedDate = Utils.getUnixTimeStamp();

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
                    color: MyStyle.whiteColor,
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
                              } else {
                                homePrice = 0;
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
                              flex: 3,
                              child: TextInputFieldWidget(
                                controller: _downPaymentTextFieldController,
                                inputType: TextInputType.number,
                                inputAction: TextInputAction.next,
                                errorText: _downPaymentError,
                                onChanged: (value) {
                                  setState(() {
                                    double? parsedValue = double.tryParse(value);
                                    if (parsedValue != null && parsedValue > 0) {
                                      downPayment = parsedValue;
                                      _downPaymentError = null;
                                    } else {
                                      downPayment = 0;
                                      _downPaymentError = value.isEmpty ? 'Please enter down payment' : 'Down payment must be positive';
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextInputContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWellWidget(
                                        onTap: () {
                                          if (downPayment > 0 && homePrice > 0) {
                                            setState(() {
                                              isDPPercentageSelected = true;
                                              calculateLoanToValue();
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isDPPercentageSelected
                                                ? MyStyle.lightGray // Dark Gray for selected
                                                : Colors.transparent, // Transparent for unselected
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                          ),
                                          child: const TextView(
                                            text: '%',
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWellWidget(
                                        onTap: () {
                                          if (downPayment > 0 && homePrice > 0) {
                                            setState(() {
                                              isDPPercentageSelected = false;
                                              calculateLoanToValue();
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: !isDPPercentageSelected
                                                ? MyStyle.lightGray // Dark Gray for selected
                                                : Colors.transparent, // Transparent for unselected
                                            borderRadius:
                                                BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                          ),
                                          child: const TextView(
                                            text: '\$',
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  TextInputFieldWidget(
                                    controller: _loanTermTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _loanTermError,
                                    onChanged: (value) {
                                      setState(() {
                                        int? parsedValue = int.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          loanTerm = parsedValue;
                                          _loanTermError = null;
                                        } else {
                                          loanTerm = 0;
                                          _loanTermError = value.isEmpty ? 'Please enter loan term' : 'Loan term must be positive';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: MyStyle.ten),
                            Expanded(
                              flex: 1,
                              child: TextInputContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: 'Yr',
                                        selectedColor: isLoanTermYearSelected ? MyStyle.lightGray : Colors.transparent,
                                        isLeftRadius: true,
                                        onTap: () {
                                          if (loanTerm > 0) {
                                            setState(() {
                                              isLoanTermYearSelected = true;
                                            });
                                            calculateMonthOrYear();
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: 'Mo',
                                        selectedColor: !isLoanTermYearSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (loanTerm > 0) {
                                            setState(() {
                                              isLoanTermYearSelected = false;
                                            });
                                            calculateMonthOrYear();
                                          }
                                        },
                                        isLeftRadius: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
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

                        /* Property tax */
                        const IconTextView(
                          text: '${Constants.propertyTax}/year',
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                        ),
                        const SizedBox(height: MyStyle.four),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  TextInputFieldWidget(
                                    controller: _propertyTaxTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _propertyTaxError,
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          propertyTax = parsedValue;
                                          _propertyTaxError = null;
                                        } else {
                                          propertyTax = 0;
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
                              flex: 1,
                              child: TextInputContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: '%',
                                        selectedColor: isPropertyTaxPercentageSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (homePrice > 0 && propertyTax > 0) {
                                            setState(() {
                                              isPropertyTaxPercentageSelected = true;
                                            });
                                            convertValue(_propertyTaxTextFieldController);
                                          }
                                        },
                                        isLeftRadius: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: '\$',
                                        selectedColor: !isPropertyTaxPercentageSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (homePrice > 0 && propertyTax > 0) {
                                            setState(() {
                                              isPropertyTaxPercentageSelected = false;
                                            });
                                            convertValue(_propertyTaxTextFieldController);
                                          }
                                        },
                                        isLeftRadius: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        /// PIM/year view
                        const IconTextView(
                          text: '${Constants.pmi}/year',
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                        ),
                        const SizedBox(height: MyStyle.four),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  TextInputFieldWidget(
                                    controller: _pmiTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _pmiError,
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          pmiPerYear = parsedValue;
                                          _pmiError = null;
                                        } else {
                                          parsedValue = 0;
                                          _pmiError = value.isEmpty ? 'Please enter PMI' : 'PIM must be positive';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: MyStyle.ten),
                            Expanded(
                              flex: 1,
                              child: TextInputContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: '%',
                                        selectedColor: isPMIPercentageSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (homePrice > 0 && pmiPerYear > 0) {
                                            setState(() {
                                              isPMIPercentageSelected = true;
                                            });
                                            convertValue(_pmiTextFieldController);
                                          }
                                        },
                                        isLeftRadius: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: '\$',
                                        selectedColor: !isPMIPercentageSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (homePrice > 0 && pmiPerYear > 0) {
                                            setState(() {
                                              isPMIPercentageSelected = false;
                                            });
                                            convertValue(_pmiTextFieldController);
                                          }
                                        },
                                        isLeftRadius: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///Home owner insurance
                        const IconTextView(
                          text: '${Constants.homeOwnerInsurance}/year',
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                        ),
                        const SizedBox(height: MyStyle.four),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  TextInputFieldWidget(
                                    controller: _homeOwnerInsTextFieldController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    errorText: _homeOwnerInsuranceError,
                                    onChanged: (value) {
                                      setState(() {
                                        double? parsedValue = double.tryParse(value);
                                        if (parsedValue != null && parsedValue > 0) {
                                          homeOwnerInsurance = parsedValue;
                                          _homeOwnerInsuranceError = null;
                                        } else {
                                          homeOwnerInsurance = 0;
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
                              flex: 1,
                              child: TextInputContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: '%',
                                        selectedColor: isHOwnerPercentageSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (homeOwnerInsurance > 0 && homePrice > 0) {
                                            setState(() {
                                              isHOwnerPercentageSelected = true;
                                            });
                                            convertValue(_homeOwnerInsTextFieldController);
                                          }
                                        },
                                        isLeftRadius: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectableTextWidget(
                                        text: '\$',
                                        selectedColor: !isHOwnerPercentageSelected ? MyStyle.lightGray : Colors.transparent,
                                        onTap: () {
                                          if (homeOwnerInsurance > 0 && homePrice > 0) {
                                            setState(() {
                                              isHOwnerPercentageSelected = false;
                                            });
                                            convertValue(_homeOwnerInsTextFieldController);
                                          }
                                        },
                                        isLeftRadius: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        ///HOA fees views
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const IconTextView(
                                    text: '${Constants.hoaFees}/month',
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

                        //Start date
                        InkWellWidget(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2019, 1),
                              lastDate: DateTime(2021, 12),
                            ).then((pickedDate) {
                              //do whatever you want
                            });
                          },
                          child: BackgroundContainer(
                            color: MyStyle.whiteColor,
                            borderRadius: 11,
                            isBorder: true,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextView(
                                      text: Utils.formatTimeStampToDate(_selectedDate!).toString(),
                                    ),
                                  ),
                                ),
                                InkWellWidget(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: MyStyle.lightGray,
                                    ),
                                    child: SvgIconWidget(iconPath: IconsConstant.icDelete),
                                  ),
                                )
                              ],
                            ),
                          ),
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

  // Function to open date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Current date by default
      firstDate: DateTime(2000),
      // Earliest date
      lastDate: DateTime(2100),
      // Latest date
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyStyle.primaryColor, // Change the color of the header (year/month navigation)
            hintColor: MyStyle.grayColor, // Change the accent color
            colorScheme: const ColorScheme.light(
              primary: MyStyle.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: MyStyle.whiteColor, // Surface (calendar grid) background color
              onSurface: MyStyle.primaryColor, // Calendar text color
            ),
            dialogBackgroundColor: Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate.toUtc().microsecondsSinceEpoch ~/ 1000;
      });
    }
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
      double homePriceValue = double.parse(_homePriceTextFieldController.text);
      double downPaymentValue =
          isDPPercentageSelected ? MortgageLoanManager.calculateDownPaymentValue(homePrice, downPayment) : downPayment;

      int loanTermValue = isLoanTermYearSelected ? loanTerm : loanTerm ~/ 12;
      double propertyTaxValue =
          isPropertyTaxPercentageSelected ? convertPercentageToAmount(total: homePrice, percentage: propertyTax) : propertyTax;

      double pmiPerYearValue = isPMIPercentageSelected ? convertPercentageToAmount(total: homePrice, percentage: pmiPerYear) : pmiPerYear;
      double annualHomeOwnerInsuranceValue =
          isHOwnerPercentageSelected ? convertPercentageToAmount(total: homePrice, percentage: homeOwnerInsurance) : homeOwnerInsurance;

      // All inputs are valid, proceed
      MortgageLoanModel updatedModel = MortgageLoanModel(
        startedAt: _selectedDate,
        homePrice: homePriceValue,
        downPayment: downPaymentValue,
        loanTerm: loanTermValue,
        // in years
        interestRate: double.parse(_interestRateTextFieldController.text),
        // in percent
        propertyTax: propertyTaxValue,
        pmi: pmiPerYearValue,
        annualHomeOwnerInsurance: annualHomeOwnerInsuranceValue,
        hoaFees: double.parse(_hoaFeesTextFieldController.text),
        title: _titleTextFieldController.text,
      );
      print('Input fields data $updatedModel');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mortgageLoanModel: updatedModel,
            isHistory: false,
          ),
        ),
      );
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
    if (homePrice > 0 && downPayment > 0) {
      setState(() {
        downPayment = isDPPercentageSelected
            ? MortgageLoanManager.calculateDownPaymentPercentage(homePrice, downPayment)
            : MortgageLoanManager.calculateDownPaymentValue(homePrice, downPayment);
        _downPaymentTextFieldController.text = downPayment.toString();
      });
    }
  }

  void calculateMonthOrYear() {
    setState(() {
      if (loanTerm > 0) {
        loanTerm = isLoanTermYearSelected ? loanTerm ~/ 12 : loanTerm * 12;
        _loanTermTextFieldController.text = loanTerm.toString();
      }
    });
  }

  void convertValue(TextEditingController controller) {
    if (controller == _propertyTaxTextFieldController) {
      if (propertyTax > 0 && homePrice > 0) {
        propertyTax = isPropertyTaxPercentageSelected
            ? convertAmountToPercentage(total: homePrice, amount: propertyTax)
            : convertPercentageToAmount(total: homePrice, percentage: propertyTax);
        setState(() {
          _propertyTaxTextFieldController.text = propertyTax.toString();
        });
      }
    }
    if (controller == _pmiTextFieldController) {
      if (pmiPerYear > 0 && homePrice > 0) {
        pmiPerYear = isPMIPercentageSelected
            ? convertAmountToPercentage(total: homePrice, amount: pmiPerYear)
            : convertPercentageToAmount(total: homePrice, percentage: pmiPerYear);
        setState(() {
          _pmiTextFieldController.text = pmiPerYear.toString();
        });
      }
    }
    if (controller == _homeOwnerInsTextFieldController) {
      if (homeOwnerInsurance > 0 && homePrice > 0) {
        homeOwnerInsurance = isHOwnerPercentageSelected
            ? convertAmountToPercentage(total: homePrice, amount: homeOwnerInsurance)
            : convertPercentageToAmount(total: homePrice, percentage: homeOwnerInsurance);
        setState(() {
          _homeOwnerInsTextFieldController.text = homeOwnerInsurance.toString();
        });
      }
    }
  }

  double convertAmountToPercentage({required double total, required double amount}) {
    if (total == 0) return 0; // Avoid division by zero
    return (amount / total) * 100; // Convert amount to percentage
  }

  double convertPercentageToAmount({required double total, required double percentage}) {
    return (percentage / 100) * total; // Convert percentage to amount
  }

  void resetFields() {
    // Clear text from all controllers
    _titleTextFieldController.clear();
    _homePriceTextFieldController.clear();
    _downPaymentTextFieldController.clear();
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
