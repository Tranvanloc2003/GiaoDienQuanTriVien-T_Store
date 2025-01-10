// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class QuanliThuongHieuModel {
  String maThuongHieu;
  String tenThuongHieu;
  String hinhAnh;
  bool? noiBat;
  int? soLuongSanPham;

  QuanliThuongHieuModel({
    required this.maThuongHieu,
    required this.tenThuongHieu,
    required this.hinhAnh,
    this.noiBat,
    this.soLuongSanPham,
  });

  static QuanliThuongHieuModel empty() => QuanliThuongHieuModel(maThuongHieu: "", tenThuongHieu: "", hinhAnh: "");

  toJson() {
    return {
      "Id": maThuongHieu,
      "Name": tenThuongHieu,
      "Image": hinhAnh,
      "IsFeatured": noiBat,
      "ProductsCount": soLuongSanPham,
    };
  }

  factory QuanliThuongHieuModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return QuanliThuongHieuModel.empty();
    }
    return QuanliThuongHieuModel(
        maThuongHieu: data["Id"] ?? "",
        tenThuongHieu: data["Name"] ?? "",
        hinhAnh: data["Image"] ?? "",
        noiBat: data["IsFeatured"] ?? false,
        soLuongSanPham: int.parse((data["ProductsCount"] ?? 0).toString()));
  }

  factory QuanliThuongHieuModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return QuanliThuongHieuModel(
          maThuongHieu: document.id,
          tenThuongHieu: data["Name"] ?? "",
          hinhAnh: data["Image"] ?? "",
          noiBat: data["IsFeatured"] ?? false,
          soLuongSanPham: data["ProductsCount"] ?? 0);
    } else {
      return QuanliThuongHieuModel.empty();
    }
  }
}
