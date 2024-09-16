import 'package:flutter/material.dart';
import 'package:mortgage_calculator/app_provider.dart';
import 'package:mortgage_calculator/common/utils/utils.dart';
import 'package:mortgage_calculator/common/widgets/alert_dialog.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/icon_text_view.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import 'package:mortgage_calculator/details_screen.dart';
import 'package:mortgage_calculator/local_db/mortgage_db_manager.dart';
import 'package:mortgage_calculator/managers/mortgage_loan_manager.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/widgets/banner_ad_widget.dart';
import 'common/widgets/elevated_button.dart';
import 'common/widgets/navigation_bar.dart';
import 'managers/result.dart';

class ResultScreen extends StatefulWidget {
  MortgageLoanModel? mortgageLoanModel;
  bool isHistory;

  ResultScreen({
    super.key,
    this.mortgageLoanModel,
    required this.isHistory,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  AppProvider? appProvider;
  late Result totalMonthlyPayment;
  Map<String, double> dataMap = {};
  MortgageLoanModel? mortgageData;

  @override
  void initState() {
    super.initState();
    mortgageData = widget.mortgageLoanModel;
    calculateResult();
  }

  Future<void> calculateResult() async {
    // var loanData = widget.mortgageLoanModel;
    if (mortgageData != null) {
      totalMonthlyPayment = MortgageLoanManager.calculateTotalMonthlyPayment(
          homePrice: mortgageData!.homePrice,
          downPayment: mortgageData!.downPayment,
          loanTermYears: mortgageData!.loanTerm,
          annualInterestRate: mortgageData!.interestRate,
          annualPropertyTax: mortgageData!.propertyTax,
          monthlyHomeOwnerInsurance: mortgageData!.homeOwnerInsurance,
          pmiAmount: mortgageData!.pmi,
          hoaFees: mortgageData!.hoaFees);
      dataMap = {
        'Principle & interest': totalMonthlyPayment.principleAndInterest,
        'Property Tax': mortgageData!.propertyTax,
        'PMI': mortgageData!.pmi,
        'Homeowner insurance': mortgageData!.homeOwnerInsurance,
        'HOA fees': mortgageData!.hoaFees
      };
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
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
                icons: widget.isHistory ? [IconsConstant.icDelete, IconsConstant.icHome] : [],
                onIconTap: (index) {
                  if (index == 0) {
                    showWarning((callback) async {
                      if (callback) {
                        await MortgageDbManager.deleteMortgage(mortgageData!);
                        appProvider!.updateProvider(updateStatus: true);
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  if (index == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailsScreen(
                                  mortgageLoanModel: mortgageData,
                                )));
                  }
                },
              ),
              const SizedBox(height: MyStyle.twenty),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: MyStyle.twenty),
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
                                                text: '\$${widget.mortgageLoanModel?.homePrice}',
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
                                                text: '\$${widget.mortgageLoanModel?.propertyTax}',
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
                                                text: '\$${widget.mortgageLoanModel?.downPayment}',
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
                                                text: '\$${widget.mortgageLoanModel?.pmi}',
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
                                                text: '${widget.mortgageLoanModel?.loanTerm} years',
                                                fontWeight: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              const TextView(
                                                  text: Constants.homeOwnerInsurance,
                                                  fontColor: MyStyle.grayColor,
                                                  fontSize: MyStyle.twelve),
                                              TextView(
                                                text: '\$${widget.mortgageLoanModel?.homeOwnerInsurance}',
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
                                                text: '${widget.mortgageLoanModel?.interestRate}%',
                                                fontWeight: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              const TextView(
                                                  text: Constants.hoaFees, fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve),
                                              TextView(
                                                text: '\$${widget.mortgageLoanModel?.hoaFees}',
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
                      if (dataMap.isNotEmpty)
                        SliverToBoxAdapter(
                          child: BackgroundContainer(
                            color: MyStyle.whiteColor,
                            borderRadius: MyStyle.twelve,
                            isBorder: false,
                            borderColor: MyStyle.whiteColor,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 26.0, bottom: 8.0),
                              child: PieChart(
                                dataMap: dataMap,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 24,
                                // Set the animation duration of the pie chart
                                animationDuration: const Duration(seconds: 1),
                                chartRadius: MediaQuery.of(context).size.width / 2.2,
                                legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.bottom,
                                  showLegendsInRow: true,
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: true,
                                  decimalPlaces: 1,
                                ),
                                centerWidget: Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    text: 'Total Monthly\npayment\n',
                                    style: const TextStyle(
                                      color: MyStyle.primaryColor,
                                      fontSize: MyStyle.twelve,
                                      fontFamily: Constants.fontFamily,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '\$${totalMonthlyPayment.totalMonthlyPayment.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MyStyle.sixteen,
                                          fontFamily: Constants.fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: MyStyle.twenty),
                          child: Button(
                              onPressed: () async {
                                if (!widget.isHistory) {
                                  mortgageData?.monthlyMortgage = totalMonthlyPayment.principleAndInterest;
                                  int currentTime = Utils.getUnixTimeStamp();
                                  mortgageData?.createdAt = currentTime;
                                  mortgageData?.updatedAt = currentTime;
                                  int status = await MortgageDbManager.insertMortgage(mortgageData!);
                                  appProvider!.updateProvider(updateStatus: true);
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              text: widget.isHistory ? 'Back' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BannerAdWidget(),
      ),
    );
  }

  void showWarning(Function(bool) callback) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogWidget(
            titleText: 'Warning',
            content: 'Are you sure you '
                'want to delete record?',
            pressedYes: () {
              Navigator.pop(context);
              callback(true);
            },
            pressedNo: () {
              Navigator.pop(context);
              callback(false);
            },
          );
        });
  }
}
