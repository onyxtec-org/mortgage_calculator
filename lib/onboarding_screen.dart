import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/ViewModels/OnBoardingViewModel.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/common/constants/my_style.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/elevated_button.dart';
import 'package:mortgage_calculator/common/widgets/icon_text_view.dart';
import 'package:mortgage_calculator/common/widgets/svg_icon_widget.dart';
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
    return ChangeNotifierProvider(
      create: (_) => OnBoardingViewModel(),
      child: Builder(builder: (context) {
        onBoardingData = Provider.of<OnBoardingViewModel>(context).onBoardingData;
        return SafeArea(
          child: Scaffold(
            body: Container(
              color: MyStyle.backgroundColor,
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: MyStyle.twentyFour, horizontal: MyStyle.twenty),
                    child: BackgroundContainer(
                        color: MyStyle.whiteColor,
                        borderRadius: MyStyle.twentyFour,
                        isBorder: false,
                        borderColor: MyStyle.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(MyStyle.twenty),
                          child: Column(
                            children: [
                              TextView(
                                text: item.title,
                                alignment: Alignment.center,
                                fontSize: MyStyle.eighteen,
                                fontWeight: FontWeight.bold,
                              ),
                              Expanded(
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: TextView(
                                      text: item.description,
                                      alignment: Alignment.center,
                                      fontSize: MyStyle.fourteen,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(vertical: MyStyle.eight, horizontal: MyStyle.twenty),
              child: Row(
                children: [
                  if (currentIndex > 0)
                    Button(
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
                  Expanded(
                    child: DotsIndicator(
                      dotsCount: onBoardingData.length,
                      position: currentIndex,
                      decorator: const DotsDecorator(
                        color: MyStyle.grayColor,
                        activeColor: MyStyle.primaryColor,
                        size: Size(10, 10),
                        spacing: EdgeInsets.all(5),
                        activeSize: Size(14, 14),
                      ),
                    ),
                  ),
                  Button(
                    onPressed: () {
                      if (currentIndex < onBoardingData.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                      }
                    },
                    text: currentIndex < onBoardingData.length - 1 ? 'Next' : 'Get Start',
                    fontSize: MyStyle.twelve,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
