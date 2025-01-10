import 'package:admin_panel/bindings/general_binding.dart';
import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/common/widgets/response/response_layout_screen.dart';
import 'package:admin_panel/common/widgets/response/screens/desktop_screen.dart';
import 'package:admin_panel/common/widgets/response/screens/mobile_screen.dart';
import 'package:admin_panel/common/widgets/response/screens/tablet_screen.dart';
import 'package:admin_panel/routes/app_routes.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBinding(),
      getPages: AppRoutes.pages,
      initialRoute: Routes.login,
      // initialRoute: Routes.homePage,
      unknownRoute: GetPage(name: '/page-not-found', page: () => const Center(child: Text('Page Not Found'))),
    );
  }
}

class ResponseDesignScreen extends StatelessWidget {
  const ResponseDesignScreen({super.key});
  
  @override 
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: Desktop(),
      tablet: Tablet(),
      mobile: Mobile()
    );
  }
}


