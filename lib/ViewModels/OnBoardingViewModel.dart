import 'package:flutter/foundation.dart';

import '../models/OnBoardingModel.dart';

class OnBoardingViewModel extends ChangeNotifier {
  final List<OnBoardingModel> _onBoardingData = OnBoardingModel.onBoardingData;

  List<OnBoardingModel> get onBoardingData => _onBoardingData;
}
