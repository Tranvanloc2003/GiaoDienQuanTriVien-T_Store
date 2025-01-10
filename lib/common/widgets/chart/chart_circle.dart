// In pubspec.yaml, update fl_chart version:
// fl_chart: ^0.66.2

// chart_circle.dart
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:admin_panel/features/shop/controllers/banner_controller.dart';
import 'package:admin_panel/features/shop/controllers/brand_controller.dart';
import 'package:admin_panel/features/shop/controllers/category_controller.dart';
import 'package:admin_panel/features/shop/controllers/product/product_controller.dart';

class PieChartExample extends StatelessWidget {
  PieChartExample({Key? key}) : super(key: key);

  Widget indicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final productController = Get.put(ProductController());
    final bannerController = Get.put(BannerController());
    final brandController = Get.put(BrandController());
    final categoryController = Get.put(CategoryController());

    return Column(
      children: [
        Text('Thống kê', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(
          height: 250,
          child: Obx(() {
            if (userController.loading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            print('Số người dùng: ${userController.userList.length}');

            print('Products: ${productController.danhSachSanPhamNoiBat.length}');
            print('Banners: ${bannerController.banners.length}');
            print('Brands: ${brandController.allBrands.length}');
            print('Categories: ${categoryController.allCategories.length}');

            return PieChart(
              PieChartData(
                sections: [
                  if (userController.userList.isNotEmpty)
                    PieChartSectionData(
                      value: userController.userList.length.toDouble(),
                      color: Colors.blue,
                      title: userController.userList.length.toString(),
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (productController.danhSachSanPhamNoiBat.isNotEmpty)
                    PieChartSectionData(
                      value: productController.danhSachSanPhamNoiBat.length.toDouble(),
                      color: Colors.green,
                      title: productController.danhSachSanPhamNoiBat.length.toString(),
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (bannerController.banners.isNotEmpty)
                    PieChartSectionData(
                      value: bannerController.banners.length.toDouble(),
                      color: Colors.yellow,
                      title: bannerController.banners.length.toString(),
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (brandController.allBrands.isNotEmpty)
                    PieChartSectionData(
                      value: brandController.allBrands.length.toDouble(),
                      color: Colors.orange,
                      title: brandController.allBrands.length.toString(),
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (categoryController.allCategories.isNotEmpty)
                    PieChartSectionData(
                      value: categoryController.allCategories.length.toDouble(),
                      color: Colors.red,
                      title: categoryController.allCategories.length.toString(),
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            indicator(Colors.blue, 'Người dùng'),
            indicator(Colors.green, 'Sản phẩm'),
            indicator(Colors.yellow, 'Quảng cáo'),
            indicator(Colors.orange, 'Thương hiệu'),
            indicator(Colors.red, 'Danh mục'),
          ],
        ),
      ],
    );
  }
}
