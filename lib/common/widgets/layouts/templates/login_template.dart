import 'package:admin_panel/common/styles/spacing_styles.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

/// Template for the login page layout
class TLoginTemplate extends StatelessWidget {
  final Widget child;
  
  const TLoginTemplate({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Container(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              color: THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}