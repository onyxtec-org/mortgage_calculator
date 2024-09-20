import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mortgage_calculator/auth_screens/change_password_screen.dart';
import 'package:mortgage_calculator/auth_screens/signin_screen.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';
import 'package:provider/provider.dart';
import '../app_provider.dart';
import '../common/constants/constants.dart';
import '../common/constants/icons_constant.dart';
import '../common/constants/my_style.dart';
import '../common/utils/shared_pref_helper.dart';
import '../common/utils/utils.dart';
import '../common/widgets/alert_dialog.dart';
import '../common/widgets/navigation_bar.dart';
import '../common/widgets/progress_dialog.dart';
import '../models/user_model.dart';
import '../network/api_error_handler.dart';
import 'common/widgets/background_container.dart';
import 'common/widgets/ink_well_widget.dart';
import 'network/network_call_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppProvider? provider;
  String? userImage;
  CroppedFile? portraitImage;
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NavBar(
              backIcon: IconsConstant.icBackArrow,
              titleText: 'Profile',
              icons: const [
                IconsConstant.icSettings,
              ],
              onIconTap: (index) async {
                String? locale = await SharedPrefHelper.retrieveStringValues('locale');
/*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                              locale: locale,
                            )));*/
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40.0),
                      Card(
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
/*                              Align(
                                alignment: Alignment.centerRight,
                                child: IntrinsicWidth(
                                  child: InkWellWidget(
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                                    },
                                    child: BackgroundContainer(
                                        color: MyStyle.primaryColor,
                                        borderRadius: 6,
                                        isBorder: false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                IconsConstant.icEditProfile,
                                                color: MyStyle.whiteColor,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              )*/
                              const AccountDetailsWidget(
                                title: 'Name',
                                value: 'Tariq usman',
                              ),
                              const AccountDetailsWidget(
                                title: 'Email',
                                value: 'tu@onyxtec.co',
                              ),
                              const AccountDetailsWidget(
                                title: 'Account status',
                                value: 'active',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      InkWellWidget(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordScreen()));
                        },
                        child: const BackgroundContainer(
                            color: MyStyle.primaryColor,
                            borderRadius: 6,
                            isBorder: false,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Update Password',
                                    style: TextStyle(color: MyStyle.whiteColor, fontSize: MyStyle.fourteen),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWellWidget(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogWidget(
                                  titleText: 'Warning!',
                                  content: 'Are you sure you want to Logout?',
                                  pressedNo: () {
                                    Navigator.of(context).pop();
                                  },
                                  pressedYes: () {
                                    logout(context, (callback) {
                                      Navigator.of(context).pop();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (_) => SignInScreen()),
                                        (Route<dynamic> route) => false,
                                      );
                                    });
                                  },
                                );
                              });
                        },
                        child: BackgroundContainer(
                            color: MyStyle.primaryColor,
                            borderRadius: 6,
                            isBorder: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    IconsConstant.icLogout,
                                    color: MyStyle.whiteColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Logout',
                                    style: TextStyle(color: MyStyle.whiteColor, fontSize: MyStyle.fourteen),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(context, Function(bool) callback) async {
    ProgressDialog.show(context, 'Please wait...');
    String? bearerToken = await SharedPrefHelper.retrieveStringValues(Constants.authToken);

    var header = NetworkCallManager().header;
    header['Authorization'] = 'Bearer $bearerToken';

    try {
      var response = await NetworkCallManager().apiCall(endPoint: ApiEndPoints.logout, queryParameters: null, body: null, header: header);
      ProgressDialog.hide(context);
      Map<String, dynamic> responseData = response;
      Utils.showToast('${responseData['message']}');
      SharedPrefHelper.removeUser();
      SharedPrefHelper.saveStringValues(Constants.authToken, null);
      callback(true);
      // provider?.changeTabBarIndex(index: 0);
      // provider?.logout();
    } on DioException catch (e) {
      ApiErrorHandler.handleError(context, e);
      ProgressDialog.hide(context);
      callback(true);
    }
  }

  void deleteUser() async {
    UserModel? user = await SharedPrefHelper.getUser();
    if (user != null) {
      try {
        ProgressDialog.show(context, "Deleting Account...");
        var response = await NetworkCallManager().apiCall(
          endPoint: ApiEndPoints.deleteUser,
        );
        if (response.statusCode == 200) {
          ProgressDialog.hide(context);
          Map<String, dynamic> data = response.data;
          Utils.showToast('${data['message']}');
          //we are removing all the date when user deletes his/her account
          SharedPrefHelper.saveStringValues(Constants.authToken, null);
          SharedPrefHelper.saveStringValues(Constants.fcmToken, null);
          SharedPrefHelper.saveStringValues(Constants.rememberEmail, null);
          SharedPrefHelper.saveStringValues(Constants.rememberPassword, null);
          SharedPrefHelper.removeUser();
          // provider?.changeTabBarIndex(index: 0);
          // provider?.logout();
        }
      } catch (error) {
        ProgressDialog.hide(context);
        ApiErrorHandler.handleError(context, error);
      }
    } else {
      Utils.showToast("Sorry :(, Unable to delete this user.");
    }
  }
}

class AccountDetailsWidget extends StatelessWidget {
  const AccountDetailsWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextView(
              text: '${title}: ',
              fontColor: MyStyle.primaryColor,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
            ),
          ),
          Flexible(
            flex: 2,
            child: TextView(
              text: value,
              fontColor: MyStyle.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
