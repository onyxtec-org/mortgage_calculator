import 'package:flutter/material.dart';

import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/widgets/background_container.dart';
import 'common/widgets/navigation_bar.dart';
import 'common/widgets/text_view.dart';
import 'models/mortgage_loan_model.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({super.key, this.mortgageLoanModel});

  MortgageLoanModel? mortgageLoanModel;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  MortgageLoanModel? mortgageData;

  @override
  void initState() {
    super.initState();
    mortgageData = widget.mortgageLoanModel;
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
                color: MyStyle.backgroundColor,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: MyStyle.twenty),
                          TextView(
                            text: mortgageData!.title,
                            fontWeight: FontWeight.bold,
                            maxLines: null,
                            textAlign: TextAlign.start,
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
                                            const TextView(
                                                text: Constants.homePrice, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.homePrice}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.propertyTax, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.propertyTax}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: MyStyle.ten),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.downPayment, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.downPayment}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(text: Constants.pmi, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.pmi}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: MyStyle.ten),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.loanTerm, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '${mortgageData?.loanTerm} years',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.homeOwnerInsurance, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.homeOwnerInsurance}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: MyStyle.ten),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.interestRate, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '${mortgageData?.interestRate}%',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(text: Constants.hoaFees, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.hoaFees}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: MyStyle.twenty),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: MyStyle.twenty),
                          TextView(
                            text: mortgageData!.title,
                            fontWeight: FontWeight.bold,
                            maxLines: null,
                            textAlign: TextAlign.start,
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
                                            const TextView(
                                                text: Constants.homePrice, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.homePrice}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.propertyTax, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.propertyTax}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: MyStyle.ten),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.downPayment, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.downPayment}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(text: Constants.pmi, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.pmi}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: MyStyle.ten),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.loanTerm, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '${mortgageData?.loanTerm} years',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.homeOwnerInsurance, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.homeOwnerInsurance}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: MyStyle.ten),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(
                                                text: Constants.interestRate, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '${mortgageData?.interestRate}%',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const TextView(text: Constants.hoaFees, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                            TextView(
                                              text: '\$${mortgageData?.hoaFees}',
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: MyStyle.twenty),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
