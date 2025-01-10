import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final danhSachSanPham = <QuanliSanPhamModel>[].obs;
  final dangTaiDuLieu = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    layDanhSachSanPham();
  }

  void layDanhSachSanPham() {
    FirebaseFirestore.instance
        .collection('Products')
        .snapshots()
        .listen((snapshot) {
      dangTaiDuLieu.value = true;
      danhSachSanPham.value = snapshot.docs
          .map((doc) => QuanliSanPhamModel.fromSnapshot(doc))
          .toList();
      dangTaiDuLieu.value = false;
    });
  }

  Future<void> xoaSanPham(QuanliSanPhamModel sanPham) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(sanPham.maSanPham)
          .delete();
      Get.snackbar('Thành công', 'Đã xóa sản phẩm');
    } catch (error) {
      Get.snackbar('Lỗi', 'Không thể xóa sản phẩm');
    }
  }

  void suaSanPham(QuanliSanPhamModel sanPham) {
    // Implement navigation to edit product screen
    // Get.toNamed('/edit-product', arguments: sanPham);
  }

  void themSanPham() {
    // Implement navigation to add product screen
    // Get.toNamed('/add-product');
  }
}
