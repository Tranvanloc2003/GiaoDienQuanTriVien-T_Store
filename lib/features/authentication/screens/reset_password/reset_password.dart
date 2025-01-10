import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/features/authentication/screens/reset_password/responsive/reset_password_desktop_tablet.dart';
import 'package:admin_panel/features/authentication/screens/reset_password/responsive/reset_password_mobile.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false,desktop: ResetPasswordDesktopTablet(),mobile: ResetPasswordMobile(),);
  }
}