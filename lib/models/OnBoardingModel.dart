class OnBoardingModel {
  final String title;
  final String description;

  OnBoardingModel({required this.title, required this.description});

  static final List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(title: 'Screen One', description: 'Screen one description'),
    OnBoardingModel(title: 'Screen Two', description: 'Screen two description'),
    OnBoardingModel(title: 'Screen Three', description: 'Screen three description'),
  ];

}
