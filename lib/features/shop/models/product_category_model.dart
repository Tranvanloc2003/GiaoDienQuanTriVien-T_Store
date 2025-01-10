import 'package:cloud_firestore/cloud_firestore.dart';

class DanhMucSanPhamModel {
  final String maSanPham;
  final String maDanhMuc;

  DanhMucSanPhamModel({
    required this.maSanPham,
    required this.maDanhMuc,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": maSanPham,
      "categoryId": maDanhMuc,
    };
  }

  factory DanhMucSanPhamModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return DanhMucSanPhamModel(
      maSanPham: data["productId"] as String,
      maDanhMuc: data["categoryId"] as String,
    );
  }
}
