import 'package:flutter/material.dart';
import 'package:mortgage_calculator/managers/mortgage_detail_model.dart';

import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/widgets/background_container.dart';
import 'common/widgets/navigation_bar.dart';
import 'common/widgets/text_view.dart';
import 'managers/mortgage_loan_manager.dart';
import 'models/mortgage_loan_model.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({super.key, this.mortgageLoanModel});

  MortgageLoanModel? mortgageLoanModel;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  MortgageLoanModel? mortgageData;
  List<MortgageDetailModel> breakdown = [];
  late TabController _tabController;
  int seletecdType = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
    mortgageData = widget.mortgageLoanModel;
    _loadMonthlyData();
  }

  void _loadMonthlyData() {
    // Initial data load
    breakdown = MortgageLoanManager.createMonthlyBreakdown(mortgageData: mortgageData!);

    // Add a listener to detect tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // Clear and update the breakdown list based on the selected tab
          if (_tabController.index == 0) {
            breakdown = MortgageLoanManager.createMonthlyBreakdown(mortgageData: mortgageData!);
          } else {
            breakdown = MortgageLoanManager.createAnnualBreakdown(mortgageData: mortgageData!);
          }
          seletecdType = _tabController.index;
        });
      }
    });
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
                titleText: Constants.detail,
                titleColor: MyStyle.whiteColor,
              ),
              const SizedBox(height: MyStyle.twenty),
              Container(
                color: MyStyle.whiteColor,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: MyStyle.primaryColor,
                  labelColor: MyStyle.primaryColor,
                  unselectedLabelColor: MyStyle.grayColor,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Monthly'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Yearly'),
                    ),
                  ],
                ),
              ),
              Container(
                color: MyStyle.primaryLightColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextView(
                          text: seletecdType == 0 ? 'Month' : 'Year',
                          fontColor: MyStyle.whiteColor,
                          fontSize: MyStyle.twelve,
                          alignment: Alignment.center,
                        ),
                      ),
                      Expanded(
                        child: TextView(
                          text: 'Mortgage',
                          fontColor: MyStyle.whiteColor,
                          fontSize: MyStyle.twelve,
                          alignment: Alignment.center,
                        ),
                      ),
                      Expanded(
                        child: TextView(
                          text: 'Principle',
                          fontColor: MyStyle.whiteColor,
                          fontSize: MyStyle.twelve,
                          alignment: Alignment.center,
                        ),
                      ),
                      Expanded(
                        child: TextView(
                          text: 'Interest',
                          fontColor: MyStyle.whiteColor,
                          fontSize: MyStyle.twelve,
                          alignment: Alignment.center,
                        ),
                      ),
                      Expanded(
                        child: TextView(
                          text: 'Balance',
                          fontColor: MyStyle.whiteColor,
                          fontSize: MyStyle.twelve,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: MyStyle.whiteColor,
                  child: CustomScrollView(
                    slivers: [
                      // Update the list based on the selected tab
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: breakdown.length,
                          (context, index) {
                            final data = breakdown[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextView(
                                          text: data.term,
                                          fontSize: MyStyle.twelve,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextView(
                                          text: data.monthlyMortgage.toStringAsFixed(2),
                                          fontSize: MyStyle.twelve,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextView(
                                          text: data.principalPaid.toStringAsFixed(2),
                                          fontSize: MyStyle.twelve,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextView(
                                          text: data.monthlyInterest.toStringAsFixed(2),
                                          fontSize: MyStyle.twelve,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextView(
                                          text: data.remainingBalance.toStringAsFixed(2),
                                          fontSize: MyStyle.twelve,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: MyStyle.lightGray,
                                  height: 1,
                                )
                              ],
                            );
                          },
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
