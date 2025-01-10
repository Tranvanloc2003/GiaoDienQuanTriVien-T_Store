import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/features/authentication/screens/login/reponsive_screens/login_desktop_tablet.dart';
import 'package:admin_panel/features/authentication/screens/login/reponsive_screens/login_mobile.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false,desktop: LoginDesktopTabletScreen(),mobile: LoginMobileScreen(),);
  }
}