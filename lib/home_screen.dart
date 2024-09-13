import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/calculator_form_screen.dart';
import 'package:mortgage_calculator/common/constants/constants.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/utils/utils.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/navigation_bar.dart';
import 'package:mortgage_calculator/common/widgets/icon_text_view.dart';
import 'package:mortgage_calculator/common/widgets/svg_icon_widget.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import 'package:mortgage_calculator/history_screen.dart';
import 'package:mortgage_calculator/local_db/mortgage_db_manager.dart';
import 'package:mortgage_calculator/result_screen.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'common/widgets/no_record_found_widget.dart';
import 'models/mortgage_loan_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppProvider? appProvider;
  List<MortgageLoanModel> mortgageHistoryData = [];
  int historyLimit = 4;

  @override
  void initState() {
    super.initState();
    fetchMortgageHistory();
  }

  Future<void> fetchMortgageHistory() async {
    mortgageHistoryData = await MortgageDbManager.fetchMortgage();
    if (appProvider != null && appProvider!.isUpdate) {
      appProvider!.updateProvider(updateStatus: false);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _stateManager();
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyStyle.primaryColor,
          width: double.infinity,
          child: Column(
            children: [
              // NavBar remains fixed at the top
              NavBar(
                titleText: "Mortgage Cal",
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
                      // Static section for Mortgage Calculator
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: MyStyle.twenty),
                          child: BackgroundContainer(
                            color: MyStyle.whiteColor,
                            borderRadius: MyStyle.twelve,
                            isBorder: false,
                            child: Padding(
                              padding: const EdgeInsets.all(MyStyle.twelve),
                              child: Row(
                                children: [
                                  const SvgIconWidget(iconPath: IconsConstant.icHome),
                                  const SizedBox(width: 20.0),
                                  const Expanded(
                                    child: TextView(
                                      text: Constants.mortgage,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Button(
                                    buttonHeight: 40,
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CalculatorFormScreen()));
                                    },
                                    text: "Calculate",
                                    fontSize: MyStyle.fourteen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: mortgageHistoryData.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: MyStyle.twenty, bottom: MyStyle.eight),
                                child: Row(
                                  children: [
                                    const TextView(
                                      text: Constants.history,
                                      fontSize: MyStyle.twenty,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const Spacer(),
                                    if (mortgageHistoryData.take(historyLimit).length > 3)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                                        },
                                        child: TextView(
                                          text: 'See all',
                                          fontColor: MyStyle.primaryLightColor,
                                          fontSize: MyStyle.twelve,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ),

                      // List section for history (scrollable)
                      mortgageHistoryData.isEmpty
                          ? const SliverToBoxAdapter(
                              child: NoRecordFoundWidget(
                                message: 'No History found',
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: mortgageHistoryData.take(historyLimit).length, // Update based on your list count
                                (context, index) {
                                  // Determine the border radius based on the index
                                  BorderRadiusGeometry borderRadius;
                                  EdgeInsets paddingVal;
                                  if (mortgageHistoryData.length == 1) {
                                    paddingVal = const EdgeInsets.symmetric(vertical: 20);
                                    borderRadius = BorderRadius.circular(MyStyle.twelve);
                                  } else if (index == 0) {
                                    paddingVal = const EdgeInsets.only(top: 20);
                                    borderRadius = const BorderRadius.vertical(top: Radius.circular(MyStyle.twelve));
                                  } else if (index == mortgageHistoryData.take(historyLimit).length - 1) {
                                    borderRadius = const BorderRadius.vertical(bottom: Radius.circular(MyStyle.twelve));
                                    paddingVal = const EdgeInsets.only(bottom: 20);
                                  } else {
                                    borderRadius = BorderRadius.zero;
                                    paddingVal = EdgeInsets.zero;
                                  }
                                  MortgageLoanModel mortgageData = mortgageHistoryData[index];
                                  return Container(
                                    padding: paddingVal,
                                    decoration: BoxDecoration(borderRadius: borderRadius, color: MyStyle.whiteColor),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: index == mortgageHistoryData.length - 1 ? 0 : MyStyle.ten,
                                          left: MyStyle.fourteen,
                                          right: MyStyle.fourteen),
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
                                                  const SizedBox(height: MyStyle.fourteen),
                                                  TextView(
                                                    text: '${mortgageData.interestRate}%',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  const TextView(text: 'Interest', fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve)
                                                ],
                                              ),
                                              const SizedBox(width: MyStyle.ten),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    TextView(
                                                      text: mortgageData.title,
                                                      textAlign: TextAlign.start,
                                                      maxLines: 1,
                                                    ),
                                                    TextView(
                                                      text: Utils.formatDate(mortgageData.createdAt!),
                                                      fontColor: MyStyle.grayColor,
                                                      fontSize: MyStyle.twelve,
                                                      textAlign: TextAlign.start,
                                                      alignment: Alignment.center,
                                                    ),
                                                    const SizedBox(height: MyStyle.fourteen),
                                                    TextView(
                                                      alignment: Alignment.center,
                                                      text: '${mortgageData.loanTerm} Years',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    const TextView(
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
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ResultScreen(
                                                            isHistory: true,
                                                            mortgageLoanModel: mortgageData,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    text: 'View',
                                                    fontSize: MyStyle.fourteen,
                                                  ),
                                                  const SizedBox(height: MyStyle.fourteen),
                                                  TextView(
                                                    text: '\$${mortgageData.homePrice}',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  const TextView(
                                                      text: 'Loan Amount', fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve)
                                                ],
                                              )
                                            ],
                                          ),
                                          if (index != mortgageHistoryData.take(historyLimit).length - 1)
                                            Container(
                                              height: 1,
                                              color: MyStyle.grayColor,
                                              margin: const EdgeInsets.only(top: MyStyle.ten),
                                            )
                                        ],
                                      ),
                                    ),
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

  void _stateManager() {
    appProvider = Provider.of<AppProvider>(context);
    if (appProvider != null && appProvider!.isUpdate) {
      print('Called');
      fetchMortgageHistory();
    }
  }
}
