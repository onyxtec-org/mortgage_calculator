import 'package:flutter/material.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';
import 'package:mortgage_calculator/result_screen.dart';

import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/widgets/background_container.dart';
import 'common/widgets/elevated_button.dart';
import 'common/widgets/navigation_bar.dart';
import 'common/widgets/normal_text_view.dart';
import 'common/widgets/svg_icon_widget.dart';
import 'common/widgets/title_text_view.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyStyle.primaryColor,
          width: double.infinity,
          child: Column(
            children: [
              // NavBar remains fixed at the top
              NavBar(
                backIcon: IconsConstant.icBackArrow,
                iconsColor: MyStyle.whiteColor,
                titleText: "History",
                titleColor: MyStyle.whiteColor,
              ),
              const SizedBox(height: MyStyle.twenty),

              // Expanded CustomScrollView for the scrollable content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: MyStyle.twenty, right: MyStyle.twenty, bottom: MyStyle.twenty),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(MyStyle.twentyFour),
                      topRight: Radius.circular(MyStyle.twentyFour),
                    ),
                    color: MyStyle.backgroundColor,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      // List section for history (scrollable)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: MyStyle.ten),
                              margin: EdgeInsets.only(bottom: index < 3 ? MyStyle.ten : 0.0, top: index == 0 ? MyStyle.twenty : 0.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(MyStyle.twelve), color: MyStyle.whiteColor),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: index == 3 ? 0 : MyStyle.ten, left: MyStyle.fourteen, right: MyStyle.fourteen),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            const BackgroundContainer(
                                              color: MyStyle.iconsBgColor,
                                              borderRadius: MyStyle.ten,
                                              isBorder: false,
                                              borderColor: MyStyle.iconsBgColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SvgIconWidget(
                                                  iconPath: IconsConstant.icHome,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MyStyle.fourteen,
                                            ),
                                            TitleTextView(
                                              text: '5.0%',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            NormalTextView(text: 'Interest', color: MyStyle.grayColor, fontSize: MyStyle.twelve)
                                          ],
                                        ),
                                        SizedBox(width: MyStyle.ten),
                                        const Expanded(
                                          child: Column(
                                            children: [
                                              TitleTextView(
                                                text: "Title text or title view",
                                                textAlign: TextAlign.start,
                                              ),
                                              NormalTextView(
                                                text: '08/06/2024',
                                                color: MyStyle.grayColor,
                                                fontSize: MyStyle.twelve,
                                                textAlign: TextAlign.start,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                height: MyStyle.fourteen,
                                              ),
                                              TitleTextView(
                                                alignment: Alignment.center,
                                                text: '12 Months',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              TitleTextView(
                                                alignment: Alignment.center,
                                                text: 'Duration',
                                                fontWeight: FontWeight.normal,
                                                fontSize: MyStyle.twelve,
                                                fontColor: MyStyle.grayColor,
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Button(
                                              buttonHeight: MyStyle.thirty,
                                              onPressed: () {
                                                MortgageLoanModel updatedModel = MortgageLoanModel(
                                                  id: 0,
                                                  homePrice: 50000.0,
                                                  // Updated value
                                                  propertyTax: 500.0,
                                                  downPayment: 20000.0,
                                                  pmi: 50.0,
                                                  loanTerm: 5,
                                                  // in years
                                                  homeOwnerInsurance: 300.0,
                                                  interestRate: 5.0,
                                                  //in percent
                                                  hoaFees: 300.0,
                                                );
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ResultScreen(
                                                              mortgageLoanModel: updatedModel,
                                                            )));
                                              },
                                              text: 'View',
                                              fontSize: MyStyle.fourteen,
                                            ),
                                            SizedBox(
                                              height: MyStyle.fourteen,
                                            ),
                                            TitleTextView(
                                              text: '5,000\$',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            NormalTextView(text: 'Investment Amount', color: MyStyle.grayColor, fontSize: MyStyle.twelve)
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: 4, // Update based on your list count
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
