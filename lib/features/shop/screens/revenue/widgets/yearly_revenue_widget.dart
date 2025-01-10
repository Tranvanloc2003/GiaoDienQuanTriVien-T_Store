import 'package:admin_panel/features/shop/controllers/orders/revenue_controller.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YearlyRevenueWidget extends StatelessWidget {
  const YearlyRevenueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RevenueController>();
    
    // Initialize yearly revenue on widget build
    controller.taiDoanhThuNam();

    return Column(
      children: [
        // Year Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                final currentYear = controller.selectedYear.value;
                if (currentYear > 2020) {
                  controller.selectedYear.value = currentYear - 1;
                  controller.taiDoanhThuNam(); // Explicitly fetch yearly revenue
                }
              },
            ),
            Obx(() => Text(
                  '${controller.selectedYear.value}',
                  style: Theme.of(context).textTheme.titleLarge,
                )),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                final currentYear = controller.selectedYear.value;
                if (currentYear < DateTime.now().year) {
                  controller.thayDoiNam(currentYear + 1);
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Revenue Display
        Obx(() {
          if (controller.isLoadingYearly.value) {
            return const CircularProgressIndicator();
          }

          final yearlyData = controller.yearlyRevenue;
          final totalRevenue = yearlyData.values.fold(0.0, (a, b) => a + b);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Tổng doanh thu năm ${controller.selectedYear.value}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalRevenue),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => controller.xuatBaoCaoNam(),
                icon: const Icon(Icons.download),
                label: const Text('Xuất báo cáo PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}