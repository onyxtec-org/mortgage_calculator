import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/normal_text_view.dart';
import 'package:mortgage_calculator/common/widgets/title_text_view.dart';
import 'package:mortgage_calculator/managers/loan_manager.dart';
import 'package:mortgage_calculator/models/loan_model.dart';

import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/widgets/elevated_button.dart';
import 'common/widgets/navigation_bar.dart';

class ResultScreen extends StatefulWidget {
  LoanModel? loanModel;

  ResultScreen({super.key, this.loanModel});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    calculateResult();
  }

  void calculateResult() {
    var loanData = widget.loanModel;
    if (loanData != null) {
      var totalMonthlyPayment = LoanManager.calculateTotalMonthlyPayment(
          homePrice: loanData.howePrice ,
          downPayment: loanData.downPayment,
          loanTermYears: loanData.loanTerm,
          annualInterestRate: loanData.interestRate,
          annualPropertyTax: loanData.propertyTax,
          annualHomeInsurance: loanData.homeOwnerInsurance,
          pmiAmount: loanData.pmi,
          hoaFees: loanData.hoaFees);
      print('Monthly total payment: ${totalMonthlyPayment.toStringAsFixed(2)}');
    }
  }

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
                titleText: Constants.result,
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
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const TitleTextView(
                              text: Constants.loanInformation,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: MyStyle.twenty),
                            BackgroundContainer(
                              color: MyStyle.whiteColor,
                              borderRadius: MyStyle.twelve,
                              borderColor: MyStyle.whiteColor,
                              isBorder: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: MyStyle.twenty, horizontal: MyStyle.ten),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.homePrice, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.howePrice}\$',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        )),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.propertyTax, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.propertyTax}\$',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: MyStyle.ten),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.downPayment, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.downPayment}\$',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        )),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(text: Constants.pmi, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.pmi}\$',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: MyStyle.ten),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.loanTerm, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.loanTerm} years',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        )),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.homeOwnerInsurance, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.homeOwnerInsurance}\$',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: MyStyle.ten),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.interestRate, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.interestRate}%',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        )),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            const NormalTextView(
                                                text: Constants.hoaFees, color: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TitleTextView(
                                              text: '${widget.loanModel?.hoaFees}\$',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TitleTextView(text: 'Total monthly payment'),
                            const SizedBox(height: MyStyle.twenty),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: double.infinity,
                          child: Button(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'Back'),
                        ),
                      ),
                    ],
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
