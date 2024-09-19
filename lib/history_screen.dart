import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/no_record_found_widget.dart';
import 'package:mortgage_calculator/local_db/mortgage_db_manager.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';
import 'package:mortgage_calculator/result_screen.dart';
import 'package:provider/provider.dart';

import 'app_provider.dart';
import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/utils/utils.dart';
import 'common/widgets/background_container.dart';
import 'common/widgets/banner_ad_widget.dart';
import 'common/widgets/elevated_button.dart';
import 'common/widgets/navigation_bar.dart';
import 'common/widgets/icon_text_view.dart';
import 'common/widgets/svg_icon_widget.dart';
import 'common/widgets/text_view.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  AppProvider? appProvider;
  List<MortgageLoanModel> mortgageDataList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    mortgageDataList = await MortgageDbManager.fetchMortgage();
    if (appProvider != null && appProvider!.isUpdate) {
      appProvider!.updateProvider(updateStatus: false);
    }
    setState(() {});
  }

  void _stateManager() {
    appProvider = Provider.of<AppProvider>(context);
    if (appProvider != null && appProvider!.isUpdate) {
      print('Called');
      _loadHistory();
    }
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
                      mortgageDataList.isEmpty
                          ? const SliverToBoxAdapter(
                              child: NoRecordFoundWidget(
                                message: 'No History found',
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: mortgageDataList.length, // Update based on your list count
                                (context, index) {
                                  MortgageLoanModel mortgageData = mortgageDataList[index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: MyStyle.ten),
                                    margin: EdgeInsets.only(
                                        bottom: index < mortgageDataList.length - 1 ? MyStyle.ten : 0.0,
                                        top: index == 0 ? MyStyle.twenty : 0.0),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(MyStyle.twelve), color: MyStyle.whiteColor),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: index == mortgageDataList.length - 1 ? 0 : MyStyle.ten,
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
                                                    text: '${mortgageData.interestRate} %',
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
                                                      text: Utils.formatTimeStampToDate(mortgageData.createdAt!),
                                                      fontColor: MyStyle.grayColor,
                                                      fontSize: MyStyle.twelve,
                                                      textAlign: TextAlign.start,
                                                      alignment: Alignment.center,
                                                    ),
                                                    const SizedBox(height: MyStyle.fourteen),
                                                    TextView(
                                                      alignment: Alignment.center,
                                                      text: '${mortgageData.loanTerm.toString()} Years',
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
                                                                    mortgageLoanModel: mortgageData,
                                                                    isHistory: true,
                                                                  )));
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
                                                      text: 'Investment Amount', fontColor: MyStyle.grayColor, fontSize: MyStyle.twelve)
                                                ],
                                              )
                                            ],
                                          ),
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
        bottomNavigationBar: BannerAdWidget(),
      ),
    );
  }
}
