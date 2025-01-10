import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:admin_panel/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
 DesktopLayout({super.key, this.body});
  final Widget? body;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Drawer(
              child: TSidebar(),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
               THeader(),

                //
                Expanded(child: body ?? SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
