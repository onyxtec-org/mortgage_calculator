import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mortgage_calculator/common/widgets/text_view.dart';

import '../constants/icons_constant.dart';
import '../constants/my_style.dart';

class NoRecordFoundWidget extends StatelessWidget {
  final String message;

  const NoRecordFoundWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              IconsConstant.icNoRecordFound,
              height: 80,
            ),
            const SizedBox(height: 10.0),
            TextView(
              text: message,
              fontColor: MyStyle.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: MyStyle.twenty,
              textAlign: TextAlign.center,
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}
