import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/constants/icons_constant.dart';
import 'package:mortgage_calculator/home_screen.dart';
import 'common/constants/constants.dart';
import 'common/constants/my_style.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isDisposed = false; // Add a flag to track the widget's disposed state

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [MyStyle.primaryColor, MyStyle.primaryLightColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background image
            Center(
              child: Image.asset(
                IconsConstant.icLogo,
                width: 160,
              ),
            ),
            // Text at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
                child: Text(
                  'Excavation  |  Demolition ',
                  style: TextStyle(
                    fontSize: MyStyle.fourteen,
                    color: MyStyle.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));

   /* Utils.requestStoragePermission(context, (isPermissionGranted) async {
      if (!_isDisposed) {
        String? bearerToken = await SharedPref.retrieveStringValues(Constants.authToken);
        if (bearerToken == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
          return;
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainController()));
      }
    });*/
  }
}
