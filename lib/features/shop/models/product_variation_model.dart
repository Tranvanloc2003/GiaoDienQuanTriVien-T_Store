// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';

class BienTheSanPhamModel {
  final String ma;
  String maSKU;
  String hinhAnh;
  String? moTa;
  XFile? tepHinhAnh;

  double gia;
  double giaGiam;
  int tonKho;
  Map<String, String> giaTriThuocTinh;

  BienTheSanPhamModel({
    required this.ma,
    this.maSKU = "",
    this.hinhAnh = "",
    this.moTa = "",
    this.gia = 0.0,
    this.giaGiam = 0.0,
    this.tonKho = 0,
    required this.giaTriThuocTinh,
  });

  //Empty helper function
  static BienTheSanPhamModel empty() => BienTheSanPhamModel(
        ma: "",
        giaTriThuocTinh: {},
      );

  toJson() {
    return {
      'Id': ma,
      'SKU': maSKU,
      'Image': hinhAnh,
      'Description': moTa,
      'Price': gia,
      'SalePrice': giaGiam,
      'Stock': tonKho,
      'AttributeValues': giaTriThuocTinh,
    };
  }

  factory BienTheSanPhamModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return BienTheSanPhamModel.empty();
    }

    return BienTheSanPhamModel(
        ma: data['Id'] ?? "",
        maSKU: data['SKU'] ?? "",
        hinhAnh: data['Image'] ?? "",
        moTa: data['Description'] ?? "",
        gia: double.parse((data['Price'] ?? 0.0).toString()),
        giaGiam: double.parse((data['SalesPrice'] ?? 0.0).toString()),
        tonKho: data['Stock'] ?? 0,
        giaTriThuocTinh: Map<String, String>.from(
          (data['AttributeValues']),
        ));
  }
}
