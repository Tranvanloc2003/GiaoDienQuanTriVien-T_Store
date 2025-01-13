import 'dart:io';

import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/features/shop/controllers/brand_controller.dart';
import 'package:admin_panel/features/shop/models/brand_model.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BrandMobile extends StatelessWidget {
  const BrandMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Quản lý Thương hiệu',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
        actions: [
          IconButton(
            onPressed: () => _showAddBrandDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Add search field
              TextField(
                controller: brandController.searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm thương hiệu...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => brandController.searchBrands(value),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              Obx(
                () => Column(
                  children: [
                    if (brandController.isLoading.value)
                      const Center(child: CircularProgressIndicator())
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: brandController.filteredBrands.length,
                        separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                        itemBuilder: (context, index) {
                          final brand = brandController.filteredBrands[index];
                          return BrandCard(brand: brand);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBrandDialog(BuildContext context) {
    final nameController = TextEditingController();
    final productsCountController = TextEditingController(text: '0');
    final controller = BrandController.instance;
    final isFeatured = false.obs;

    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Giới hạn chiều cao tối đa
          ),
          child: Scaffold( // Wrap trong Scaffold để có resizeToAvoidBottomInset
            resizeToAvoidBottomInset: true, // Thêm thuộc tính này
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thêm thương hiệu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: () {
                            controller.brandImageFile.value = null;
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Form Fields
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thương hiệu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    TextField(
                      controller: productsCountController,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Featured Checkbox
                    Obx(() => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Thương hiệu nổi bật'),
                      value: isFeatured.value,
                      onChanged: (value) => isFeatured.value = value ?? false,
                    )),
                    
                    // Image Picker
                    const Text('Hình ảnh thương hiệu'),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            controller.setBrandImage(image);
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Obx(() => controller.brandImageFile.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(controller.brandImageFile.value!.path),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty) {
                                controller.taoThuongHieu(
                                  name: nameController.text,
                                  productsCount: int.tryParse(productsCountController.text) ?? 0,
                                  isFeatured: isFeatured.value,
                                );
                                Get.back();
                              }
                            },
                            child: const Text('Thêm'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Ngăn đóng dialog khi click bên ngoài
    );
  }

  void _showEditBrandDialog(BuildContext context, QuanliThuongHieuModel brand) {
    final nameController = TextEditingController(text: brand.tenThuongHieu);
    final productsCountController = TextEditingController(text: brand.soLuongSanPham?.toString() ?? '0');
    final controller = BrandController.instance;
    final isFeatured = (brand.noiBat ?? false).obs;

    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sửa thương hiệu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: () {
                            controller.brandImageFile.value = null;
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Form Fields
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thương hiệu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    TextField(
                      controller: productsCountController,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Featured Checkbox
                    Obx(() => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Thương hiệu nổi bật'),
                      value: isFeatured.value,
                      onChanged: (value) => isFeatured.value = value ?? false,
                    )),
                    
                    // Image Picker
                    const Text('Hình ảnh thương hiệu'),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            controller.setBrandImage(image);
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Obx(() => controller.brandImageFile.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(controller.brandImageFile.value!.path),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  brand.hinhAnh,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty) {
                                final updatedBrand = QuanliThuongHieuModel(
                                  maThuongHieu: brand.maThuongHieu,
                                  tenThuongHieu: nameController.text,
                                  hinhAnh: brand.hinhAnh,
                                  soLuongSanPham: int.tryParse(productsCountController.text) ?? 0,
                                  noiBat: isFeatured.value,
                                );
                                controller.capNhatThuongHieu(updatedBrand);
                                Get.back();
                              }
                            },
                            child: const Text('Cập nhật'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class BrandCard extends StatelessWidget {
  final QuanliThuongHieuModel brand;

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      showBorder: true,
      backgroundColor: dark ? TColors.dark : TColors.light,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.sm),
              image: DecorationImage(
                image: NetworkImage(brand.hinhAnh),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.tenThuongHieu,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (brand.soLuongSanPham != null)
                  Text(
                    '${brand.soLuongSanPham} Products',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => _showEditBrandDialog(context, brand),
                icon: const Icon(Icons.edit, size: 20),
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context, brand.maThuongHieu),
                icon: const Icon(Icons.delete, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String brandId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa thương hiệu này?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              
              Get.back();
              
              final controller = BrandController.instance;
              await controller.xoaThuongHieu(brandId);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showEditBrandDialog(BuildContext context, QuanliThuongHieuModel brand) {
    final nameController = TextEditingController(text: brand.tenThuongHieu);
    final productsCountController = TextEditingController(text: brand.soLuongSanPham?.toString() ?? '0');
    final controller = BrandController.instance;
    final isFeatured = (brand.noiBat ?? false).obs;

    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sửa thương hiệu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: () {
                            controller.brandImageFile.value = null;
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Form Fields
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thương hiệu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    TextField(
                      controller: productsCountController,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Featured Checkbox
                    Obx(() => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Thương hiệu nổi bật'),
                      value: isFeatured.value,
                      onChanged: (value) => isFeatured.value = value ?? false,
                    )),
                    
                    // Image Picker
                    const Text('Hình ảnh thương hiệu'),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            controller.setBrandImage(image);
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Obx(() => controller.brandImageFile.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(controller.brandImageFile.value!.path),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  brand.hinhAnh,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty) {
                                final updatedBrand = QuanliThuongHieuModel(
                                  maThuongHieu: brand.maThuongHieu,
                                  tenThuongHieu: nameController.text,
                                  hinhAnh: brand.hinhAnh,
                                  soLuongSanPham: int.tryParse(productsCountController.text) ?? 0,
                                  noiBat: isFeatured.value,
                                );
                                controller.capNhatThuongHieu(updatedBrand);
                                Get.back();
                              }
                            },
                            child: const Text('Cập nhật'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}