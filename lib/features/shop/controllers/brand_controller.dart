import 'package:admin_panel/data/repository/brand/brand_repository.dart';
import 'package:admin_panel/data/repository/product/product_repository.dart';
import 'package:admin_panel/data/services/firebase_storage_service.dart';
import 'package:admin_panel/features/shop/models/brand_model.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  //Variables
  RxBool isLoading = true.obs;
  final RxList<QuanliThuongHieuModel> allBrands = <QuanliThuongHieuModel>[].obs;
  final RxList<QuanliThuongHieuModel> featuredBrands = <QuanliThuongHieuModel>[].obs;
  final brandRepository = Get.put(BrandRepository());
  final brandImageFile = Rx<XFile?>(null);

  @override
  void onInit() {
    layThuongHieuNoiBat(); // Load brands when controller initializes
    super.onInit();
  }

  //getfeatured brads
  Future<void> layThuongHieuNoiBat() async {
    try {
      //Show Loader
      isLoading.value = true;

      final brandsList = await brandRepository.layTatCaThuongHieu();
      allBrands.assignAll(brandsList);
      featuredBrands.assignAll(
          allBrands.where((brand) => brand.noiBat ?? false).take(4));
    } catch (e) {
      TLoaders.errorSnackBar(title: "Ôi Không!", message: e.toString());
    } finally {
      //Stop Loader
      isLoading.value = false;
    }
  }

  // Add method to set image
  void setBrandImage(XFile image) {
    brandImageFile.value = image;
    update();
  }

  Future<void> taoThuongHieu({
    required String name,
    required int productsCount,
    required bool isFeatured,
  }) async {
    try {
      isLoading.value = true;

      if (brandImageFile.value == null) {
        TLoaders.errorSnackBar(
          title: 'Lỗi',
          message: 'Vui lòng chọn hình ảnh thương hiệu'
        );
        return;
      }

      // Upload image to Firebase Storage
      final storage = Get.find<TFirebaseStorageService>();
      final imageUrl = await storage.taiHinhAnhFile(
        'Brands/Images',
        brandImageFile.value!
      );
      
      // Create brand with image URL
      final brand = QuanliThuongHieuModel(
        maThuongHieu: "",
        tenThuongHieu: name,
        hinhAnh: imageUrl,
        soLuongSanPham: productsCount,
        noiBat: isFeatured,
      );
      
      await brandRepository.taoThuongHieu(brand);
      await layThuongHieuNoiBat();
      
      // Reset image file
      brandImageFile.value = null;
      
      TLoaders.successSnackBar(title: 'Success', message: 'Brand created successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> capNhatThuongHieu(QuanliThuongHieuModel brand) async {
    try {
      isLoading.value = true;

      // Upload new image if selected
      if (brandImageFile.value != null) {
        final storage = Get.find<TFirebaseStorageService>();
        final imageUrl = await storage.taiHinhAnhFile(
          'Brands/Images',
          brandImageFile.value!
        );
        brand.tenThuongHieu = imageUrl;
      }
      
      await brandRepository.capNhatThuongHieu(brand);
      await layThuongHieuNoiBat();
      
      // Reset image file
      brandImageFile.value = null;
      
      TLoaders.successSnackBar(title: 'Success', message: 'Brand updated successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> xoaThuongHieu(String brandId) async {
    try {
      isLoading.value = true;
      await brandRepository.xoaThuongHieu(brandId);
      // Refresh the brands list
      await layThuongHieuNoiBat();
      TLoaders.successSnackBar(title: 'Xóa Thành Công', message: 'Thương hiệu đã được xóa!');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
