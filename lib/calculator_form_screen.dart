import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/navigation_bar.dart';
import 'package:mortgage_calculator/common/widgets/normal_text_view.dart';
import 'package:mortgage_calculator/common/widgets/text_input_field_widget.dart';
import 'package:mortgage_calculator/models/loan_model.dart';
import 'package:mortgage_calculator/result_screen.dart';

import 'common/constants/constants.dart';

class CalculatorFormScreen extends StatefulWidget {
  const CalculatorFormScreen({super.key});

  @override
  State<CalculatorFormScreen> createState() => _CalculatorFormScreenState();
}

class _CalculatorFormScreenState extends State<CalculatorFormScreen> {
  String? _homePriceError;
  String? _downPaymentError;
  String? _loanTermError;
  String? _interestRateError;
  String? _propertyTaxError;
  String? _pmiError;
  String? _homeOwnerInsuranceError;
  String? _hoaFeesError;

  final TextEditingController _homePriceTextFieldController = TextEditingController();
  final TextEditingController _downPaymentTextFieldController = TextEditingController();
  final TextEditingController _downPaymentPercentTextFieldController = TextEditingController();
  final TextEditingController _loanTermTextFieldController = TextEditingController();
  final TextEditingController _interestRateTextFieldController = TextEditingController();
  final TextEditingController _propertyTaxTextFieldController = TextEditingController();
  final TextEditingController _pmiTextFieldController = TextEditingController();
  final TextEditingController _homeOwnerInsTextFieldController = TextEditingController();
  final TextEditingController _hoaFeesTextFieldController = TextEditingController();

  LoanModel? model;

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
                        NormalTextView(
                          text: Constants.homePrice,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: true,
                          onTapIcon: () {},
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
                              // _nameError = value.isEmpty ? 'Add Amount' : null;
                            });
                          },
                        ),

                        /* Down Payment views */
                        NormalTextView(
                          text: Constants.downPayment,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: true,
                          onTapIcon: () {
                            print("clicked");
                          },
                        ),
                        const SizedBox(height: MyStyle.four),
                        Row(
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
                                    // _nameError = value.isEmpty ? 'Add Amount' : null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextInputFieldWidget(
                                controller: _downPaymentPercentTextFieldController,
                                inputType: TextInputType.number,
                                inputAction: TextInputAction.next,
                                // errorText: _,
                                suffixText: '%',
                                onChanged: (value) {
                                  setState(() {
                                    // _nameError = value.isEmpty ? 'Add Amount' : null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        /* Loan Term view*/
                        NormalTextView(
                          text: Constants.loanTerm,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: true,
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
                              // _nameError = value.isEmpty ? 'Add Amount' : null;
                            });
                          },
                        ),

                        /* Interest Rate view*/
                        NormalTextView(
                          text: Constants.interestRate,
                          color: MyStyle.primaryColor,
                          fontSize: MyStyle.fourteen,
                          isIcons: true,
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
                              // _nameError = value.isEmpty ? 'Add Amount' : null;
                            });
                          },
                        ),

                        /* Property tax and  PMI view*/
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    const NormalTextView(
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
                                          // _nameError = value.isEmpty ? 'Add Amount' : null;
                                        });
                                      },
                                    ),
                                  ],
                                )),
                            const SizedBox(width: MyStyle.ten),
                            Expanded(
                                child: Column(
                                  children: [
                                    const NormalTextView(
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
                                          // _nameError = value.isEmpty ? 'Add Amount' : null;
                                        });
                                      },
                                    ),
                                  ],
                                ))
                          ],
                        ),

                        /* Home owner insurance and HOA fees views */
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    const NormalTextView(
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
                                          // _nameError = value.isEmpty ? 'Add Amount' : null;
                                        });
                                      },
                                    ),
                                  ],
                                )),
                            const SizedBox(width: MyStyle.ten),
                            Expanded(
                                child: Column(
                                  children: [
                                    const NormalTextView(
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
                                          // _nameError = value.isEmpty ? 'Add Amount' : null;
                                        });
                                      },
                                    ),
                                  ],
                                ))
                          ],
                        ),

                        /* Calculate button */
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                              onPressed: () {


                                LoanModel updatedModel = LoanModel(
                                  id: model?.id,
                                  howePrice: 2.0,
                                  // Updated value
                                  propertyTax: model?.propertyTax ?? 0.0,
                                  downPayment: model?.downPayment ?? 0.0,
                                  pmi: model?.pmi ?? 0.0,
                                  loanTerm: model?.loanTerm ?? 0.0,
                                  homeOwnerInsurance: model?.homeOwnerInsurance ?? 0.0,
                                  interestRate: model?.interestRate ?? 0.0,
                                  hoaFees: model?.hoaFees ?? 0.0,
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResultScreen(
                                              loanModel: updatedModel,
                                            )));
                              },
                              text: Constants.calculate),
                        ),
                        const SizedBox(height: MyStyle.twenty),

                        /* Reset fields button */
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                            onPressed: () {},
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
}


