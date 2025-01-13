import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/common/widgets/layouts/grid_layout.dart';
import 'package:admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:admin_panel/features/shop/screens/products/widgets/add_product.dart';
import 'package:admin_panel/features/shop/screens/products/widgets/edit_product.dart';
import 'package:admin_panel/features/shop/screens/products/widgets/product_card.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductMobileScreen extends StatelessWidget {
  const ProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Quản lý sản phẩm'),
        showBackArrow: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => const AddProductScreen());
              // Refresh product list when returning from add screen
              controller.layDanhSachSanPhamNoiBat();
            },
            icon: const Icon(Iconsax.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TextField(
                controller: controller.searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.searchProducts(value),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              Obx(() {
                if (controller.dangTaiDuLieu.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return const Center(child: Text('Không có sản phẩm nào'));
                }

                return TGridLayout(
                  itemCount: controller.filteredProducts.length,
                  mainAxisExtent: 280,
                  itemBuilder: (_, index) => ProductCardAdmin(
                    sanPham: controller.filteredProducts[index],
                    onPressed: () {
                      Get.to(() => EditProductScreen(
                        product: controller.filteredProducts[index]
                      ));
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}