import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/common/widgets/chart/chart_circle.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:admin_panel/data/repository/authentication/authentication_repository.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/shop/screens/revenue/widgets/daily_revenue_widget.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DashboardMobileScreen extends StatelessWidget {
  DashboardMobileScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final dark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: const TSidebar(),
      appBar: TAppBar(
        scaffoldKey: _scaffoldKey,
        leadingIcon: Iconsax.menu,
        title: Text(
          "Quản Trị Viên",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Đăng xuất",
                middleText: "Bạn có chắc chắn muốn đăng xuất không?",
                textConfirm: "Đăng xuất",
                textCancel: "Hủy",
                confirmTextColor: TColors.white,
                onConfirm: () => AuthenticationRepository.instance.dangXuat(),
              );
            },
            icon: Icon(
              Icons.logout,
              color: dark ? TColors.light : TColors.dark,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //ten admin
              Obx(() {
                if (userController.loading.value) {
                  return const TShimmerEffect(height: 15.0, width: 80.0);
                } else {
                  return Text("Xin chào, ${userController.user.value.fullName}",
                      style: Theme.of(context).textTheme.headlineMedium);
                }
              }),
              SizedBox(height: TSizes.spaceBtwItems),
              
              // quan li nguoi dung
              Column(
                children: [
                  PieChartExample(),
                  SizedBox(height: TSizes.spaceBtwItems),
                 
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
