import 'package:flutter/material.dart';
import 'package:mortgage_calculator/calculator_form_screen.dart';
import 'package:mortgage_calculator/common/constants/constants.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/navigation_bar.dart';
import 'package:mortgage_calculator/common/widgets/normal_text_view.dart';
import 'package:mortgage_calculator/common/widgets/svg_icon_widget.dart';
import 'package:mortgage_calculator/common/widgets/title_text_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                titleText: "Mortgage Cal",
                titleColor: MyStyle.whiteColor,
              ),
              const SizedBox(height: MyStyle.twenty),

              // Expanded CustomScrollView for the scrollable content
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
                      // Static section for Mortgage Calculator
                      SliverToBoxAdapter(
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
                                  child: TitleTextView(
                                    text: Constants.mortgage,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Button(
                                  buttonHeight: 40,
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorFormScreen()));
                                  },
                                  text: "Calculate",
                                  fontSize: MyStyle.fourteen,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: MyStyle.twenty, bottom: MyStyle.eight),
                          child: TitleTextView(
                            text: Constants.history,
                            fontSize: MyStyle.twenty,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // List section for history (scrollable)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Determine the border radius based on the index
                            BorderRadiusGeometry borderRadius;
                            EdgeInsets paddingVal;
                            if (index == 0) {
                              paddingVal = const EdgeInsets.only(top: 20);
                              borderRadius = const BorderRadius.vertical(top: Radius.circular(MyStyle.twelve));
                            } else if (index == 3) {
                              borderRadius = const BorderRadius.vertical(bottom: Radius.circular(MyStyle.twelve));
                              paddingVal = const EdgeInsets.only(bottom: 20);
                            } else {
                              borderRadius = BorderRadius.zero;
                              paddingVal = EdgeInsets.zero;
                            }
                            return Container(
                              padding: paddingVal,
                              decoration: BoxDecoration(borderRadius: borderRadius, color: MyStyle.whiteColor),
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
                                              height: MyStyle.ten,
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TitleTextView(text: "Title text or title view"),
                                              NormalTextView(
                                                text: '08/06/2024',
                                                color: MyStyle.grayColor,
                                                fontSize: MyStyle.twelve,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: MyStyle.ten,
                                              ),
                                              TitleTextView(
                                                alignment: Alignment.center,
                                                text: '12 Months',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              NormalTextView(
                                                text: 'Duration',
                                                color: MyStyle.grayColor,
                                                fontSize: MyStyle.twelve,
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.center,
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Button(
                                              buttonHeight: MyStyle.thirty,
                                              onPressed: () {},
                                              text: 'View',
                                              fontSize: MyStyle.fourteen,
                                            ),
                                            SizedBox(
                                              height: MyStyle.ten,
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
                                    if (index != 3)
                                      Container(
                                        height: 1,
                                        color: MyStyle.grayColor,
                                        margin: EdgeInsets.only(top: MyStyle.ten),
                                      )
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
