import 'package:admin_panel/features/shop/controllers/orders/revenue_controller.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

class MonthlyRevenueWidget extends StatelessWidget {
  const MonthlyRevenueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RevenueController>();
    
    // Initialize monthly revenue on widget build
    controller.taiDoanhThuThang();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                final newDate = DateTime(
                  controller.selectedMonthDate.value.year,
                  controller.selectedMonthDate.value.month - 1,
                );
                controller.thayDoiThang(newDate);
              },
            ),
            Obx(() => Text(
                  DateFormat('MM/yyyy').format(controller.selectedMonthDate.value),
                  style: Theme.of(context).textTheme.titleLarge,
                )),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                final newDate = DateTime(
                  controller.selectedMonthDate.value.year,
                  controller.selectedMonthDate.value.month + 1,
                );
                if (newDate.isBefore(DateTime.now())) {
                  controller.thayDoiThang(newDate);
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Revenue Display
        Obx(() {
          if (controller.isLoadingMonthly.value) {
            return const CircularProgressIndicator();
          }

          final monthlyData = controller.monthlyRevenue;
          final totalRevenue = monthlyData.values.fold(0.0, (a, b) => a + b);

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
                      'Tổng doanh thu tháng ${DateFormat('MM/yyyy').format(controller.selectedMonthDate.value)}',
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
                onPressed: () => controller.xuatBaoCaoThang(),
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