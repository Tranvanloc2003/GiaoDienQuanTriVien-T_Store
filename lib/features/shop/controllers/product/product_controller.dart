import 'package:admin_panel/data/repository/product/product_repository.dart';
import 'package:admin_panel/data/services/firebase_storage_service.dart';
import 'package:admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/features/shop/models/product_variation_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final _khoSanPham = Get.put(ProductRepository());
  final formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController tieuDeController;
  late TextEditingController giaController;
  late TextEditingController giaGiamController;
  late TextEditingController tonKhoController;
  late TextEditingController moTaController;

  // Observable variables
  RxList<QuanliSanPhamModel> danhSachSanPhamNoiBat = <QuanliSanPhamModel>[].obs;
  final dangTaiDuLieu = false.obs;
  final sanPhamMoi = QuanliSanPhamModel.empty().obs;
  final laSanPhamBienThe = false.obs;

  // Default attributes
  final thuocTinhMacDinh = [
    ProductAttributeModel(ten: 'Color', giaTriList: []),
    ProductAttributeModel(ten: 'Size', giaTriList: [])
  ];

  // Image handling
  final tepAnhDaiDien = Rx<XFile?>(null);
  final anhMoi = <XFile>[].obs;
  final anhHienTai = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    khoiTaoController();
    layDanhSachSanPhamNoiBat();
  }

  void khoiTaoController() {
    tieuDeController = TextEditingController();
    giaController = TextEditingController();
    giaGiamController = TextEditingController();
    tonKhoController = TextEditingController();
    moTaController = TextEditingController();
  }

  void toggleProductType(bool isVariable) {
    laSanPhamBienThe.value = isVariable;
    if (isVariable) {
      sanPhamMoi.value.thuocTinhSanPham = thuocTinhMacDinh;
      sanPhamMoi.value.loaiSanPham = ProductType.variable.toString();
    } else {
      sanPhamMoi.value.thuocTinhSanPham = [];
      sanPhamMoi.value.bienTheSanPham = [];
      sanPhamMoi.value.loaiSanPham = ProductType.single.toString();
    }
  }

  void updateAttributeValues(int index, String valuesString) {
    sanPhamMoi.value.thuocTinhSanPham![index].capNhatGiaTriTuChuoi(valuesString);
    update();
  }

  void addVariation(BienTheSanPhamModel variation) {
    sanPhamMoi.value.bienTheSanPham ??= [];
    sanPhamMoi.value.bienTheSanPham!.add(variation);
    update();
  }

  void setThumbnailImage(XFile image) {
    tepAnhDaiDien.value = image;
    sanPhamMoi.value.anhDaiDien = image.path;
    update();
  }

  void resetForm() {
    sanPhamMoi.value = QuanliSanPhamModel.empty();
    tepAnhDaiDien.value = null;
    anhMoi.clear();
    anhHienTai.clear();
    laSanPhamBienThe.value = false;
    tieuDeController.clear();
    giaController.clear();
    giaGiamController.clear();
    tonKhoController.clear();
    moTaController.clear();
    sanPhamMoi.value.thuongHieu = null;
    sanPhamMoi.value.maDanhMuc = null;
    thuocTinhMacDinh.clear();
    thuocTinhMacDinh.addAll([
      ProductAttributeModel(ten: 'Color', giaTriList: []),
      ProductAttributeModel(ten: 'Size', giaTriList: [])
    ]);
    sanPhamMoi.value.thuocTinhSanPham = [];
    sanPhamMoi.value.bienTheSanPham = [];
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }
    update();
  }

  Future<void> taoSanPham() async {
    try {
      dangTaiDuLieu.value = true;

      String thumbnailUrl = '';
      if (tepAnhDaiDien.value != null) {
        final storage = Get.find<TFirebaseStorageService>();
        thumbnailUrl = await storage.taiHinhAnhFile(
          'Products/Images',
          tepAnhDaiDien.value!
        );
      }

      List<String> imageUrls = [];
      if (sanPhamMoi.value.danhSachAnh != null && sanPhamMoi.value.danhSachAnh!.isNotEmpty) {
        final storage = Get.find<TFirebaseStorageService>();
        for (var image in sanPhamMoi.value.danhSachAnh!) {
          final imageUrl = await storage.taiHinhAnhFile(
            'Products/Images',
            XFile(image)
          );
          imageUrls.add(imageUrl);
        }
      }

      if (sanPhamMoi.value.bienTheSanPham != null) {
        for (var variation in sanPhamMoi.value.bienTheSanPham!) {
          if (variation.tepHinhAnh != null) {
            final storage = Get.find<TFirebaseStorageService>();
            variation.hinhAnh = await storage.taiHinhAnhFile(
              'Products/Variations',
              variation.tepHinhAnh!
            );
          }
        }
      }

      final product = sanPhamMoi.value;
      product.anhDaiDien = thumbnailUrl;
      product.danhSachAnh = imageUrls;
      product.noiBat = true;
      product.maSKU = "SKU${DateTime.now().millisecondsSinceEpoch}";
      product.tonKho = int.tryParse(tonKhoController.text) ?? 0;
      product.gia = double.tryParse(giaController.text) ?? 0.0;
      product.giaGiam = double.tryParse(giaGiamController.text) ?? 0.0;
      product.tenSanPham = tieuDeController.text;
      product.moTa = moTaController.text;
      product.loaiSanPham = laSanPhamBienThe.value 
        ? ProductType.variable.toString() 
        : ProductType.single.toString();

      await _khoSanPham.taoSanPham(product);

      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Sản phẩm đã được tạo'
      );

      resetForm();
      await layDanhSachSanPhamNoiBat();
      Get.back();

    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: e.toString()
      );
    } finally {
      dangTaiDuLieu.value = false;
    }
  }

  Future<void> layDanhSachSanPhamNoiBat() async {
    try {
      dangTaiDuLieu.value = true;
      final products = await _khoSanPham.laySanPhamNoiBat(limit: -1);
      danhSachSanPhamNoiBat.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Ôi Không!", message: e.toString());
    } finally {
      dangTaiDuLieu.value = false;
    }
  }

  Future<void> xoaSanPham(String productId) async {
    try {
      dangTaiDuLieu.value = true;
      await _khoSanPham.xoaSanPham(productId);
      await layDanhSachSanPhamNoiBat();
      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đã xóa sản phẩm'
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: e.toString()
      );
    } finally {
      dangTaiDuLieu.value = false;
    }
  }

  void initializeEditForm(QuanliSanPhamModel product) {
    try {
      resetForm();
      tieuDeController.text = product.tenSanPham;
      giaController.text = product.gia.toString();
      giaGiamController.text = product.giaGiam.toString();
      tonKhoController.text = product.tonKho.toString();
      moTaController.text = product.moTa ?? '';
      sanPhamMoi.value = product;
      laSanPhamBienThe.value = product.loaiSanPham == ProductType.variable.toString();
      if (laSanPhamBienThe.value && product.thuocTinhSanPham != null) {
        thuocTinhMacDinh.clear();
        thuocTinhMacDinh.addAll(product.thuocTinhSanPham!);
      }
      if (product.danhSachAnh != null) {
        anhHienTai.assignAll(product.danhSachAnh!);
      }
      update();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể load thông tin sản phẩm: $e'
      );
    }
  }

  Future<void> capNhatSanPham(String productId) async {
    try {
      dangTaiDuLieu.value = true;

      String thumbnailUrl = sanPhamMoi.value.anhDaiDien;
      if (tepAnhDaiDien.value != null) {
        final storage = Get.find<TFirebaseStorageService>();
        thumbnailUrl = await storage.taiHinhAnhFile(
          'Products/Images',
          tepAnhDaiDien.value!
        );
      }

      List<String> imageUrls = sanPhamMoi.value.danhSachAnh ?? [];
      if (anhMoi.isNotEmpty) {
        final storage = Get.find<TFirebaseStorageService>();
        for (var image in anhMoi) {
          final imageUrl = await storage.taiHinhAnhFile(
            'Products/Images',
            image
          );
          imageUrls.add(imageUrl);
        }
      }

      if (sanPhamMoi.value.bienTheSanPham != null) {
        for (var variation in sanPhamMoi.value.bienTheSanPham!) {
          if (variation.tepHinhAnh != null) {
            final storage = Get.find<TFirebaseStorageService>();
            variation.hinhAnh = await storage.taiHinhAnhFile(
              'Products/Variations',
              variation.tepHinhAnh!
            );
          }
        }
      }

      final product = sanPhamMoi.value;
      product.anhDaiDien = thumbnailUrl;
      product.danhSachAnh = imageUrls;
      product.tonKho = int.tryParse(tonKhoController.text) ?? 0;
      product.gia = double.tryParse(giaController.text) ?? 0.0;
      product.giaGiam = double.tryParse(giaGiamController.text) ?? 0.0;
      product.tenSanPham = tieuDeController.text;
      product.moTa = moTaController.text;

      await _khoSanPham.capNhatSanPham(productId, product);

      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Sản phẩm đã được cập nhật'
      );

      resetForm();
      await layDanhSachSanPhamNoiBat();
      Get.back();

    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: e.toString()
      );
    } finally {
      dangTaiDuLieu.value = false;
    }
  }

  @override
  void dispose() {
    resetForm();
    tieuDeController.dispose();
    giaController.dispose();
    giaGiamController.dispose();
    tonKhoController.dispose();
    moTaController.dispose();
    super.dispose();
  }
}
 