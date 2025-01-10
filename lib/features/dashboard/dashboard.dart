import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';


import 'package:admin_panel/features/dashboard/responsive/dashboard_desktop.dart';
import 'package:admin_panel/features/dashboard/responsive/dashboard_mobile.dart';
import 'package:admin_panel/features/dashboard/responsive/dashboard_tablet.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(useLayout:false,mobile: DashboardMobileScreen(),);
  }
}