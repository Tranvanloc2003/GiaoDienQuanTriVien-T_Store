import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    this.height,
    this.width,
    this.radius = TSizes.cardRadiusLg,
    this.padding,
    this.showBorder = false,
    this.margin,
    this.child,
    this.backgroundColor = TColors.white,
    this.borderColor = TColors.borderPrimary,
    this.onTap,
    this.showbackgroundColor = false,
  });

  final double? height;
  final double? width;
  final double radius;
  final bool showBorder;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final bool showbackgroundColor;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
        child: Card(
       
          shadowColor: Colors.white.withOpacity(.5),
          color: showbackgroundColor ? backgroundColor : dark ? TColors.dark : TColors.light,
          margin: margin,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(TSizes.md),
            child: child ?? const SizedBox(),
          ),
        ),
      ),
    );
  }
}
