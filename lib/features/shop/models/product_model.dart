// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:admin_panel/features/shop/models/brand_model.dart';
import 'package:admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:admin_panel/features/shop/models/product_variation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuanliSanPhamModel {
  String maSanPham;
  int tonKho;
  String? maSKU;
  double gia;
  String tenSanPham;
  DateTime? ngayTao;
  double giaGiam;
  String anhDaiDien;
  bool? noiBat;
  QuanliThuongHieuModel? thuongHieu;
  String? moTa;
  String? maDanhMuc;
  List<String>? danhSachAnh;
  String loaiSanPham;
  List<ProductAttributeModel>? thuocTinhSanPham;
  List<BienTheSanPhamModel>? bienTheSanPham;

  QuanliSanPhamModel({
    required this.maSanPham,
    required this.tonKho,
    required this.gia,
    required this.tenSanPham,
    required this.anhDaiDien,
    required this.loaiSanPham,
    this.giaGiam = 0.0,
    this.maSKU,
    this.ngayTao,
    this.thuongHieu,
    this.moTa,
    this.noiBat,
    this.maDanhMuc,
    this.danhSachAnh,
    this.thuocTinhSanPham,
    this.bienTheSanPham,
  });

  static QuanliSanPhamModel empty() => QuanliSanPhamModel(
        maSanPham: "",
        tonKho: 0,
        gia: 0,
        tenSanPham: "",
        anhDaiDien: "",
        loaiSanPham: "single",
        noiBat: true,
        giaGiam: 0,
        ngayTao: null,
        moTa: "",
        danhSachAnh: [],
        thuocTinhSanPham: [],
        bienTheSanPham: [],
      );

  toJson() {
    return {
      'SKU': maSKU,
      'Title': tenSanPham,
      'Stock': tonKho,
      'Price': gia,
      'Images': danhSachAnh ?? [],
      'Thumbnail': anhDaiDien,
      'SalePrice': giaGiam,
      'IsFeatured': noiBat ?? true,
      'CategoryId': maDanhMuc,
      'Brand': thuongHieu?.toJson(),
      'Description': moTa,
      'ProductType': loaiSanPham,
      'Date': ngayTao,
      'ProductAttributes': thuocTinhSanPham != null
          ? thuocTinhSanPham!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': bienTheSanPham != null
          ? bienTheSanPham!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  factory QuanliSanPhamModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return QuanliSanPhamModel.empty();
    
    final data = document.data()!;
    return QuanliSanPhamModel(
      maSanPham: document.id,
      tenSanPham: data["Title"],
      maSKU: data["SKU"],
      tonKho: data['Stock'] ?? 0,
      noiBat: data["IsFeatured"] ?? false,
      gia: double.parse((data["Price"] ?? 0.0).toString()),
      giaGiam: double.parse((data["SalePrice"] ?? 0.0).toString()),
      anhDaiDien: data["Thumbnail"] ?? "",
      maDanhMuc: data["CategoryId"] ?? "",
      moTa: data["Description"] ?? "",
      loaiSanPham: data["ProductType"] ?? "",
      thuongHieu: QuanliThuongHieuModel.fromJson(data["Brand"]),
      danhSachAnh: data["Images"] != null ? List<String>.from(data["Images"]) : [],
      thuocTinhSanPham: (data["ProductAttributes"] as List<dynamic>)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList(),
      bienTheSanPham: (data["ProductVariations"] as List<dynamic>)
          .map((e) => BienTheSanPhamModel.fromJson(e))
          .toList(),
    );
  }

  factory QuanliSanPhamModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return QuanliSanPhamModel(
      maSanPham: document.id,
      tenSanPham: data["Title"] ?? "",
      maSKU: data["SKU"] ?? "",
      tonKho: data['Stock'] ?? 0,
      noiBat: data["IsFeatured"] ?? false,
      gia: double.parse((data["Price"] ?? 0.0).toString()),
      giaGiam: double.parse((data["SalePrice"] ?? 0.0).toString()),
      anhDaiDien: data["Thumbnail"] ?? "",
      maDanhMuc: data["CategoryId"] ?? "",
      moTa: data["Description"] ?? "",
      loaiSanPham: data["ProductType"] ?? "",
      thuongHieu: QuanliThuongHieuModel.fromJson(data["Brand"]),
      danhSachAnh: data["Images"] != null ? List<String>.from(data["Images"]) : [],
      thuocTinhSanPham: (data["ProductAttributes"] as List<dynamic>)
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList(),
      bienTheSanPham: (data["ProductVariations"] as List<dynamic>)
          .map((e) => BienTheSanPhamModel.fromJson(e))
          .toList(),
    );
  }
}
