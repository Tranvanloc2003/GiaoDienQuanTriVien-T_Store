import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/image_strings.dart';


class TLoaderAnimation extends StatelessWidget {
  const TLoaderAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(TImages.defaultLoaderAnimation, height: 200, width: 200));
  }
}