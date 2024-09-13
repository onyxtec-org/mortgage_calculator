import 'package:mortgage_calculator/common/constants/icons_constant.dart';

class OnBoardingModel {
  final String gifPath;
  final String title;
  final String description;

  OnBoardingModel({required this.gifPath, required this.title, required this.description});

  static final List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(gifPath: IconsConstant.welcomeGif, title: 'Welcome', description: 'Welcome content'),
    OnBoardingModel(gifPath: IconsConstant.calculateMortgageGif, title: 'Calculate Mortgage', description: 'Calculate Mortgage content'),
    OnBoardingModel(gifPath: IconsConstant.resultGif, title: 'Result', description: 'Result content'),
    OnBoardingModel(gifPath: IconsConstant.historyGif, title: 'Save History', description: 'Save history content'),
    OnBoardingModel(gifPath: IconsConstant.getStartedGif, title: 'Get Started', description: 'Get started content'),
  ];
}
