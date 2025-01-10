import 'dart:io';

import 'package:admin_panel/features/shop/controllers/brand_controller.dart';
import 'package:admin_panel/features/shop/controllers/category_controller.dart';
import 'package:admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/features/shop/models/product_variation_model.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatelessWidget {
  final QuanliSanPhamModel product;
  
  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final brandController = Get.find<BrandController>();
    final categoryController = Get.find<CategoryController>();
    
    // Initialize form with product data
    controller.initializeEditForm(product);
    
    final formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async {
        controller.resetForm();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chỉnh sửa sản phẩm'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.resetForm();
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin cơ bản
                  TextFormField(
                    controller: controller.tieuDeController,
                    decoration: const InputDecoration(labelText: 'Tên sản phẩm *'),
                    onChanged: (value) => controller.sanPhamMoi.value.tenSanPham = value,
                    validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập tên sản phẩm' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Giá và kho
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.giaController,
                          decoration: const InputDecoration(labelText: 'Giá *'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => controller.sanPhamMoi.value.gia = double.tryParse(value) ?? 0,
                          validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập giá' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: controller.giaGiamController,
                          decoration: const InputDecoration(labelText: 'Giá khuyến mãi'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => controller.sanPhamMoi.value.giaGiam = double.tryParse(value) ?? 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: controller.tonKhoController,
                    decoration: const InputDecoration(labelText: 'Số lượng trong kho *'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => controller.sanPhamMoi.value.tonKho = int.tryParse(value) ?? 0,
                    validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập số lượng' : null,
                  ),
                  const SizedBox(height: 16),

                  // Mô tả
                  TextFormField(
                    controller: controller.moTaController,
                    decoration: const InputDecoration(labelText: 'Mô tả sản phẩm'),
                    maxLines: 3,
                    onChanged: (value) => controller.sanPhamMoi.value.moTa = value,
                  ),
                  const SizedBox(height: 16),

                  // Ảnh sản phẩm
                  const Text('Ảnh đại diện sản phẩm *'),
                  const SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          controller.setThumbnailImage(image);
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Obx(() {
                          if (controller.tepAnhDaiDien.value != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(controller.tepAnhDaiDien.value!.path),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else if (controller.sanPhamMoi.value.anhDaiDien.isNotEmpty) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                controller.sanPhamMoi.value.anhDaiDien,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: Colors.grey,
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Thương hiệu và danh mục
                  Obx(() => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Thương hiệu *'),
                    value: controller.sanPhamMoi.value.thuongHieu?.maThuongHieu,
                    items: brandController.allBrands.map((brand) => 
                      DropdownMenuItem(
                        value: brand.maThuongHieu,
                        child: Text(brand.tenThuongHieu),
                      )
                    ).toList(),
                    onChanged: (value) => controller.sanPhamMoi.value.thuongHieu = 
                      brandController.allBrands.firstWhere((brand) => brand.maThuongHieu == value),
                    validator: (value) => value?.isEmpty ?? true ? 'Vui lòng chọn thương hiệu' : null,
                  )),
                  const SizedBox(height: 16),

                  Obx(() => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Danh mục *'),
                    value: controller.sanPhamMoi.value.maDanhMuc,
                    items: categoryController.allCategories.map((category) => 
                      DropdownMenuItem(
                        value: category.maDanhMuc,
                        child: Text(category.tenDanhMuc),
                      )
                    ).toList(),
                    onChanged: (value) => controller.sanPhamMoi.value.maDanhMuc = value ?? '',
                    validator: (value) => value?.isEmpty ?? true ? 'Vui lòng chọn danh mục' : null,
                  )),
                  const SizedBox(height: 24),

                  // Loại sản phẩm
                  const Text('Loại sản phẩm *'),
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Sản phẩm đơn'),
                          value: false,
                          groupValue: controller.laSanPhamBienThe.value,
                          onChanged: (bool? value) {
                            if (value != null) {
                              controller.toggleProductType(value);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Sản phẩm biến thể'),
                          value: true,
                          groupValue: controller.laSanPhamBienThe.value,
                          onChanged: (bool? value) {
                            if (value != null) {
                              controller.toggleProductType(value);
                            }
                          },
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 16),

                  // Phần thuộc tính và biến thể
                  Obx(() => controller.laSanPhamBienThe.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Thuộc tính sản phẩm', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          
                          // Form nhập thuộc tính
                          GetBuilder<ProductController>(
                            builder: (_) => Column(
                              children: controller.sanPhamMoi.value.thuocTinhSanPham!.map((attr) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextFormField(
                                      initialValue: attr.giaTriList.join(', '),
                                      decoration: InputDecoration(
                                        labelText: 'Giá trị cho ${attr.ten} (phân cách bằng dấu phẩy)',
                                        helperText: 'Ví dụ: Đỏ, Xanh, Vàng',
                                      ),
                                      onChanged: (value) {
                                        controller.updateAttributeValues(
                                          controller.sanPhamMoi.value.thuocTinhSanPham!.indexOf(attr),
                                          value
                                        );
                                      },
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    children: attr.giaTriList.map((value) => Chip(
                                      label: Text(value),
                                      backgroundColor: Colors.blue.shade100,
                                    )).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              )).toList(),
                            ),
                          ),
                          
                          const Divider(height: 32),
                          
                          // Biến thể
                          const Text('Biến thể sản phẩm', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                              child: ElevatedButton.icon(
                                onPressed: () => _showAddVariationDialog(context, controller),
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm biến thể'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Danh sách biến thể
                          GetBuilder<ProductController>(
                            builder: (_) {
                              final variations = controller.sanPhamMoi.value.bienTheSanPham ?? [];
                              if (variations.isEmpty) {
                                return const Center(
                                  child: Text('Chưa có biến thể nào', 
                                    style: TextStyle(fontStyle: FontStyle.italic)
                                  ),
                                );
                              }
                              
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: variations.length,
                                itemBuilder: (context, index) => _buildVariationCard(
                                  context, variations[index], index, controller
                                ),
                              );
                            }
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
                  ),
                  
                  const SizedBox(height: 32),

                  // Nút cập nhật
                  Center(
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.dangTaiDuLieu.value 
                        ? null 
                        : () async {
                            if (formKey.currentState!.validate()) {
                              await controller.capNhatSanPham(product.maSanPham);
                            }
                          },
                      child: controller.dangTaiDuLieu.value
                        ? const CircularProgressIndicator()
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                          child: const Text('Cập nhật sản phẩm'),
                        ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVariationCard(BuildContext context, BienTheSanPhamModel variation, 
      int index, ProductController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: variation.giaTriThuocTinh.entries
                      .map((e) => Text(
                        '${e.key}: ${e.value}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )).toList(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.sanPhamMoi.update((val) {
                      val?.bienTheSanPham?.removeAt(index);
                    });
                    controller.update();
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giá: ${variation.gia}'),
                      if (variation.giaGiam > 0)
                        Text('Giá KM: ${variation.giaGiam}'),
                      Text('Kho: ${variation.tonKho}'),
                    ],
                  ),
                ),
                if (variation.tepHinhAnh != null || variation.hinhAnh.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: variation.tepHinhAnh != null
                      ? Image.file(
                          File(variation.tepHinhAnh!.path),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          variation.hinhAnh,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 

  void _showAddVariationDialog(BuildContext context, ProductController controller) {
  final formKey = GlobalKey<FormState>();
  final selectedImage = Rx<XFile?>(null);
  final variation = BienTheSanPhamModel(
    ma: DateTime.now().millisecondsSinceEpoch.toString(),
    giaTriThuocTinh: {},
  );

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Thêm biến thể'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Attribute Selection Section
              ...controller.sanPhamMoi.value.thuocTinhSanPham!.map((attr) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: attr.ten,
                      border: OutlineInputBorder(),
                    ),
                    items: attr.giaTriList.map((value) =>
                      DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      )
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        variation.giaTriThuocTinh[attr.ten] = value;
                      }
                    },
                    validator: (value) => value == null ? 'Vui lòng chọn ${attr.giaTriList}' : null,
                  ),
                )
              ),

              const Divider(height: 32),

              // 2. Image Selection Section
              const Text('Ảnh biến thể', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      selectedImage.value = image;
                      variation.tepHinhAnh = image;
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Obx(() => selectedImage.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(selectedImage.value!.path),
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

              const Divider(height: 32),

              // 3. Pricing Section
              const Text('Thông tin giá', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Giá *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => variation.gia = double.tryParse(value) ?? 0,
                      validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập giá' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Giá khuyến mãi',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => variation.giaGiam = double.tryParse(value) ?? 0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 4. tonKho and Description Section
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Số lượng trong kho *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => variation.tonKho = int.tryParse(value) ?? 0,
                validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập số lượng' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mô tả biến thể',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) => variation.moTa = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              controller.addVariation(variation);
              Navigator.pop(context);
            }
          },
          child: const Text('Thêm'),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),
  );
}
}