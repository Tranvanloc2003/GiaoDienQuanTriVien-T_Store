import 'package:admin_panel/common/widgets/response/layout/desktop_layout.dart';
import 'package:admin_panel/common/widgets/response/layout/mobile_layout.dart';
import 'package:admin_panel/common/widgets/response/layout/tablet_layout.dart';
import 'package:admin_panel/common/widgets/response/response_layout_screen.dart';
import 'package:flutter/material.dart';

class SiteTemplate extends StatelessWidget {
  const SiteTemplate({super.key, this.desktop, this.tablet, this.mobile, this.useLayout = true});
  final Widget? desktop;


  final Widget? tablet;


  final Widget? mobile;

  final bool useLayout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponseLayoutWidget(desktop:useLayout ? DesktopLayout(body: desktop,): desktop?? Container(), tablet:useLayout? TabletLayout(body: tablet ?? desktop,): tablet ?? desktop ?? Container(), mobile:useLayout? MobileLayout(body: mobile ?? desktop,): mobile??desktop ?? Container(),),
    );
  }
}