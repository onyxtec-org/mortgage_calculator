import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/ViewModels/OnBoardingViewModel.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/widgets/banner_ad_widget.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import 'package:mortgage_calculator/home_screen.dart';
import 'package:provider/provider.dart';

import 'models/OnBoardingModel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoardingModel> onBoardingData = [];
  int currentIndex = 0; // Keep track of the current page index
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (_) => OnBoardingViewModel(),
      child: Builder(builder: (context) {
        onBoardingData = Provider.of<OnBoardingViewModel>(context).onBoardingData;
        return SafeArea(
          child: Scaffold(
            body: Container(
              color: MyStyle.primaryColor,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(MyStyle.twenty),
                          bottomRight: Radius.circular(MyStyle.twenty),
                        ),
                        color: MyStyle.whiteColor,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: MyStyle.twenty),
                          Image.asset(
                            IconsConstant.icLogo,
                            width: 60,
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: onBoardingData.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final item = onBoardingData[index];
                                return OnBoardingWidget(item: item, screenWidth: screenWidth);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.25,
                    padding: const EdgeInsets.symmetric(vertical: MyStyle.eight, horizontal: MyStyle.ten),
                    child: Column(
                      children: [
                        const Spacer(),
                        Stack(
                          children: [
                            if (currentIndex > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Button(
                                  buttonColor: MyStyle.whiteColor,
                                  textColor: MyStyle.primaryColor,
                                  onPressed: () {
                                    if (currentIndex > 0) {
                                      _pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  text: 'Back',
                                  fontSize: MyStyle.twelve,
                                ),
                              ),
                            Align(
                              alignment: Alignment.center,
                              child: DotsIndicator(
                                dotsCount: onBoardingData.length,
                                position: currentIndex,
                                decorator: const DotsDecorator(
                                  color: MyStyle.grayColor,
                                  activeColor: MyStyle.whiteColor,
                                  size: Size(10, 10),
                                  spacing: EdgeInsets.all(5),
                                  activeSize: Size(MyStyle.eighteen, MyStyle.eighteen),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Button(
                                buttonColor: MyStyle.whiteColor,
                                textColor: MyStyle.primaryColor,
                                onPressed: () {
                                  if (currentIndex < onBoardingData.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                                  }
                                },
                                text: currentIndex < onBoardingData.length - 1 ? 'Next' : 'Get Started',
                                fontSize: MyStyle.twelve,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: MyStyle.ten,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(child: BannerAdWidget(),),
          ),
        );
      }),
    );
  }
}

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.item,
    required this.screenWidth,
  });

  final OnBoardingModel item;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MyStyle.twenty),
      child: Column(
        children: [
          Image.asset(item.gifPath, height: screenWidth / 2),
          const SizedBox(height: MyStyle.twenty),
          TextView(
            text: item.title,
            alignment: Alignment.center,
            fontSize: MyStyle.twenty,
            fontWeight: FontWeight.bold,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: MyStyle.twenty),
                  TextView(
                    text: item.description,
                    alignment: Alignment.center,
                    fontSize: MyStyle.fourteen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
