import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mortgage_calculator/app_provider.dart';
import 'package:mortgage_calculator/splash_screen.dart';
import 'package:provider/provider.dart';

import 'common/constants/my_style.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await dotenv.load(fileName: "lib/.env");
  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyStyle.primaryColor,
      ),
      home: SplashScreen(),
    );
  }
}
