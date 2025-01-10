import 'dart:io';
import 'dart:typed_data';
import 'package:admin_panel/data/services/firebase_storage_service.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  //Variables
  //Getall Products
  Future<List<QuanliSanPhamModel>> laySanPhamNoiBat({int limit = 4}) async {
    try {
      final snapshot = (limit == -1)
          ? await _db
              .collection("SanPham")
              .where("IsFeatured", isEqualTo: true)
              .get()
          : await _db
              .collection("SanPham")
              .where("IsFeatured", isEqualTo: true)
              .limit(4)
              .get();

      return snapshot.docs.map((e) => QuanliSanPhamModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong. Please try again";
    }
  }   
  Future<List<QuanliSanPhamModel>> timKiemSanPham(String tuKhoa) async {
    try {
      if (tuKhoa.isEmpty) return [];

      final tuKhoaVietThuong = tuKhoa.toLowerCase();

      final snapshot = await _db
          .collection('SanPham')
          .where('IsFeatured', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => QuanliSanPhamModel.fromSnapshot(doc))
          .where((sanPham) =>
              sanPham.tenSanPham.toLowerCase().contains(tuKhoaVietThuong) ||
              sanPham.moTa!.toLowerCase().contains(tuKhoaVietThuong) ||
              sanPham.thuongHieu!.tenThuongHieu.toLowerCase().contains(tuKhoaVietThuong) ||
              sanPham.maDanhMuc!.toLowerCase().contains(tuKhoaVietThuong))
          .toList();

    } catch (e) {
      throw 'Đã xảy ra lỗi khi tìm kiếm sản phẩm';
    }
  }

  Future<void> taoSanPham(QuanliSanPhamModel sanPham) async {
    try {
      final maNew = await taoIdSanPhamMoi();
      sanPham.maSanPham = maNew;

      final Map<String, dynamic> duLieu = {
        'Id': sanPham.maSanPham,
        'Title': sanPham.tenSanPham,
        'Description': sanPham.moTa,
        'Price': sanPham.gia,
        'SalePrice': sanPham.giaGiam,
        'SKU': sanPham.maSKU ?? "SKU${DateTime.now().millisecondsSinceEpoch}",
        'Stock': sanPham.tonKho,
        'Thumbnail': sanPham.anhDaiDien,
        'Images': sanPham.danhSachAnh ?? [],
        'CategoryId': sanPham.maDanhMuc,
        'IsFeatured': sanPham.noiBat ?? true,
        'ProductType': sanPham.loaiSanPham,
        'Brand': sanPham.thuongHieu?.toJson(),
        'ProductAttributes': sanPham.thuocTinhSanPham?.map((e) => e.toJson()).toList() ?? [],
        'ProductVariations': sanPham.bienTheSanPham?.map((e) => e.toJson()).toList() ?? [],
        'Date': FieldValue.serverTimestamp(),
      };

      await _db.collection("SanPham").doc(maNew).set(duLieu);

    } catch (e) {
      throw 'Không thể tạo sản phẩm mới: $e';
    }
  }


  Future<void> xoaSanPham(String productId) async {
    try {
      await _db.collection("SanPham").doc(productId).delete();
    } catch (e) {
      throw 'Không thể xóa sản phẩm: $e';
    }
  }

  Future<String> taoIdSanPhamMoi() async {
    try {
      // Lấy tất cả sản phẩm và sắp xếp theo ID giảm dần
      final snapshot = await _db.collection("SanPham").get();
      
      if (snapshot.docs.isEmpty) {
        return "1";
      }

      // Tìm ID lớn nhất
      int maxId = 0;
      for (var doc in snapshot.docs) {
        int currentId = int.tryParse(doc.id) ?? 0;
        if (currentId > maxId) {
          maxId = currentId;
        }
      }
      
      // Tăng ID lên 1
      return (maxId + 1).toString();
      
    } catch (e) {
      throw 'Không thể tạo ID sản phẩm mới: $e';
    }
  }

  Future<void> capNhatSanPham(String productId, QuanliSanPhamModel product) async {
    try {
      final Map<String, dynamic> data = {
        'Title': product.tenSanPham,
        'Description': product.moTa,
        'Price': product.gia,
        'SalePrice': product.giaGiam,
        'SKU': product.maSKU,
        'Stock': product.tonKho,
        'Thumbnail': product.anhDaiDien,
        'Images': product.danhSachAnh,
        'CategoryId': product.maDanhMuc,
        'IsFeatured': product.noiBat,
        'ProductType': product.loaiSanPham,
        'Brand': product.thuongHieu?.toJson(),
        'ProductAttributes': product.thuocTinhSanPham?.map((e) => e.toJson()).toList() ?? [],
        'ProductVariations': product.bienTheSanPham?.map((e) => e.toJson()).toList() ?? [],
        'Date': FieldValue.serverTimestamp(),
      };

      await _db.collection("SanPham").doc(productId).update(data);
    } catch (e) {
      throw 'Không thể cập nhật sản phẩm: $e';
    }
  }
}