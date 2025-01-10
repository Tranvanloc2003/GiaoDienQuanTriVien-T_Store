import 'package:admin_panel/data/services/firebase_storage_service.dart';
import 'package:admin_panel/features/shop/models/brand_model.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  //Get all brands
  Future<List<QuanliThuongHieuModel>> layTatCaThuongHieu() async {
    try {
      final snapshot = await _db.collection("ThuongHieu").get();
      final result = snapshot.docs
          .map((document) => QuanliThuongHieuModel.fromSnapshot(document))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Someting went wrong. Please try again";
    }
  }

  // Get next available ID
  Future<String> layIdTiepTheo() async {
    try {
      final snapshot = await _db.collection("ThuongHieu").get();
      final ids = snapshot.docs.map((doc) => int.tryParse(doc.id) ?? 0).toList();
      if (ids.isEmpty) return "1";
      return (ids.reduce((a, b) => a > b ? a : b) + 1).toString();
    } catch (e) {
      throw "Error generating next ID";
    }
  }

  // Create a new brand
  Future<void> taoThuongHieu(QuanliThuongHieuModel brand) async {
    try {
      final nextId = await layIdTiepTheo();
      await _db.collection("ThuongHieu").doc(nextId).set(brand.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update brand
  Future<void> capNhatThuongHieu(QuanliThuongHieuModel brand) async {
    try {
      await _db.collection("ThuongHieu").doc(brand.maThuongHieu).set(brand.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete brand
  Future<void> xoaThuongHieu(String brandId) async {
    try {
      await _db.collection("ThuongHieu").doc(brandId.toString()).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
