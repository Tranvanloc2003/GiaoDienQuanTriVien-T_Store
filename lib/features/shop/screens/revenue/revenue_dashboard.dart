import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/features/shop/controllers/orders/revenue_controller.dart';
import 'package:admin_panel/features/shop/screens/revenue/widgets/daily_revenue_widget.dart';
import 'package:admin_panel/features/shop/screens/revenue/widgets/monthly_revenue_widget.dart';
import 'package:admin_panel/features/shop/screens/revenue/widgets/yearly_revenue_widget.dart';
import 'package:admin_panel/utils/popups/loaders.dart';

import 'package:flutter/material.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:get/get.dart';

class RevenueDashboard extends StatelessWidget {
  const RevenueDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller using put instead of find
    final controller = Get.put(RevenueController());
    
    return Scaffold(
      appBar: TAppBar(
        title: const Text('Thống Kê Doanh Thu'),
        showBackArrow: true,
       
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DailyRevenueWidget(),
                const SizedBox(height: TSizes.spaceBtwSections),
                const MonthlyRevenueWidget(),
                const SizedBox(height: TSizes.spaceBtwSections),
                const YearlyRevenueWidget(),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
