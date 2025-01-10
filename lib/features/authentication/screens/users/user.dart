import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/features/authentication/screens/users/responsive/user_mobile.dart';
import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout: false,mobile: UserMobile(),);
  }
}