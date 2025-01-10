import 'package:admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCardAdmin extends StatelessWidget {
  const ProductCardAdmin({
    super.key,
    required this.sanPham,
    this.onPressed,
  });

  final QuanliSanPhamModel sanPham;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          border: Border.all(color: Colors.grey),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh sản phẩm
                CachedNetworkImage(
                  imageUrl: sanPham.anhDaiDien,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Tên sản phẩm
                Text(
                  sanPham.tenSanPham,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                // Giá sản phẩm
                Text(
                  '\$${sanPham.gia}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                // Số lượng còn lại
                Text(
                  'Còn lại: ${sanPham.tonKho}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            
            // Thêm nút xóa ở góc phải
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Xác nhận xóa',
                    middleText: 'Bạn có chắc muốn xóa sản phẩm này?',
                    textConfirm: 'Xóa',
                    textCancel: 'Hủy',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.find<ProductController>().xoaSanPham(sanPham.maSanPham);
                      Get.back();
                    },
                    onCancel: () => Get.back(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}