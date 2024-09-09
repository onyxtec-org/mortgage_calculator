import 'package:flutter/material.dart';
import 'package:mortgage_calculator/common/widgets/background_container.dart';
import 'package:mortgage_calculator/common/widgets/normal_text_view.dart';
import 'package:mortgage_calculator/common/widgets/title_text_view.dart';
import 'package:mortgage_calculator/models/loan_model.dart';

import 'common/constants/constants.dart';
import 'common/constants/icons_constant.dart';
import 'common/constants/my_style.dart';
import 'common/widgets/elevated_button.dart';
import 'common/widgets/navigation_bar.dart';

class ResultScreen extends StatefulWidget {
  LoanModel? loanModel;

  ResultScreen({super.key, this.loanModel});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyStyle.primaryColor,
          width: double.infinity,
          child: Column(
            children: [
              NavBar(
                backIcon: IconsConstant.icBackArrow,
                iconsColor: MyStyle.whiteColor,
                titleText: Constants.result,
                titleColor: MyStyle.whiteColor,
              ),
              const SizedBox(height: MyStyle.twenty),
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
                      const SliverToBoxAdapter(
                        child: Column(
                          children: [
                            TitleTextView(
                              text: Constants.loanInformation,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: MyStyle.twenty),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: BackgroundContainer(
                          color: MyStyle.whiteColor,
                          borderRadius: MyStyle.twenty,
                          isBorder: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: MyStyle.twenty, horizontal: MyStyle.ten),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3.0, // Adjust this value if needed
                              ),
                              itemCount: widget.loanModel?.data.length ?? 0,
                              shrinkWrap: true,
                              // Allows GridView to take only the needed space
                              physics: const NeverScrollableScrollPhysics(),
                              // Prevents internal scrolling
                              itemBuilder: (context, index) {
                                // Get the entry from the map
                                var key = widget.loanModel?.data.keys.elementAt(index);
                                var value = widget.loanModel?.data[key];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      NormalTextView(
                                        text: key ?? '',
                                        color: MyStyle.grayColor,
                                        fontSize: MyStyle.twelve,
                                      ),
                                      TitleTextView(
                                        text: value,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: MyStyle.twenty),
                          child: Button(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'Back'),
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
