import 'package:admin_panel/features/shop/controllers/orders/revenue_controller.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

class DailyRevenueWidget extends StatelessWidget {
  const DailyRevenueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RevenueController());
    
    // Initialize daily revenue on widget build
    controller.taiDoanhThuNgay();

    return Column(
      children: [
        // Date Picker
        CalendarDatePicker(
          initialDate: controller.selectedDailyDate.value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          onDateChanged: (date) => controller.thayDoiNgay(date),
        ),

        const SizedBox(height: 20),

        // Revenue Display
        Obx(() {
          if (controller.isLoadingDaily.value) {
            return const CircularProgressIndicator();
          }

          final dailyData = controller.dailyRevenue;
          final totalRevenue = dailyData.values.fold(0.0, (a, b) => a + b);
          
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
                      'Doanh Thu Ngày ${DateFormat('dd/MM/yyyy').format(controller.selectedDailyDate.value)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalRevenue),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => controller.xuatBaoCaoNgay(),
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