import 'package:admin_panel/features/shop/controllers/product/image_controller.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/features/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  //Variables
  RxMap thuocTinhDaChon = {}.obs;
  RxString trangThaiTonKhoBienThe = "".obs;
  Rx<BienTheSanPhamModel> bienTheDaChon = BienTheSanPhamModel.empty().obs;

  void onThuocTinhDuocChon(QuanliSanPhamModel sanPham, tenThuocTinh, giaTri) {
    final thuocTinhDaChon = Map<String, dynamic>.from(this.thuocTinhDaChon);
    thuocTinhDaChon[tenThuocTinh] = giaTri;
    this.thuocTinhDaChon[tenThuocTinh] = giaTri;

    final bienTheDaChon = sanPham.bienTheSanPham!.firstWhere(
        (bienThe) => kiemTraGiaTriThuocTinh(
            bienThe.giaTriThuocTinh, thuocTinhDaChon),
        orElse: () => BienTheSanPhamModel.empty());

    if (bienTheDaChon.hinhAnh.isNotEmpty) {
      ImageController.instance.selectedProductImage.value = bienTheDaChon.hinhAnh;
    }
  }

  bool kiemTraGiaTriThuocTinh(Map<String, dynamic> thuocTinhBienThe,
      Map<String, dynamic> thuocTinhDaChon) {
    if (thuocTinhBienThe.length != thuocTinhDaChon.length) return false;

    for (final key in thuocTinhBienThe.keys) {
      if (thuocTinhBienThe[key] != thuocTinhDaChon[key]) return false;
    }
    return true;
  }

  String layGiaBienThe() {
    return (bienTheDaChon.value.giaGiam > 0
            ? bienTheDaChon.value.giaGiam
            : bienTheDaChon.value.gia)
        .toString();
  }

  Set<String?> layThuocTinhKhaDung(
    List<BienTheSanPhamModel> danhSachBienThe,
    String tenThuocTinh,
  ) {
    final thuocTinhKhaDung = danhSachBienThe
        .where((bienThe) =>
            bienThe.giaTriThuocTinh[tenThuocTinh] != null &&
            bienThe.giaTriThuocTinh[tenThuocTinh]!.isNotEmpty &&
            bienThe.tonKho > 0)
        .map((bienThe) => bienThe.giaTriThuocTinh[tenThuocTinh])
        .toSet();
    return thuocTinhKhaDung;
  }

  void layTrangThaiTonKhoBienThe() {
    trangThaiTonKhoBienThe.value =
        bienTheDaChon.value.tonKho > 0 ? "Còn hàng" : "Hết hàng";
  }

  void datLaiThuocTinh() {
    thuocTinhDaChon.clear();
    trangThaiTonKhoBienThe.value = "";
    bienTheDaChon.value = BienTheSanPhamModel.empty();
  }
}
