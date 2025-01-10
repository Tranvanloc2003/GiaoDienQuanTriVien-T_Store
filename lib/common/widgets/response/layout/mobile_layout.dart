import 'package:admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
   MobileLayout({super.key, this.body});
final Widget? body;
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body ?? Container(),
    );
  }
}