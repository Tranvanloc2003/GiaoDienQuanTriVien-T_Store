import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/features/authentication/screens/forget_password/response/forget_password_desktop.dart';
import 'package:admin_panel/features/authentication/screens/forget_password/response/forget_password_mobile.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false,desktop: ForgetPasswordDesktopTablet(),mobile: ForgetPasswordMobile(),);
  }
}