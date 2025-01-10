import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/features/shop/screens/banners/responsive/banner_mobile.dart';
import 'package:flutter/material.dart';

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false,mobile: BannerMobile(),);
  }
}