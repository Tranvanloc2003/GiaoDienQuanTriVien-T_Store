import 'package:admin_panel/data/services/firebase_storage_service.dart';
import 'package:admin_panel/features/shop/models/banner_model.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  //Getall banners
  Future<List<QuanliBannerModel>> taiBanner() async {
    try {
      final result = await _db
          .collection("Banners")
          .where("Active", isEqualTo: true)
          .get();
      final list = result.docs
          .map((document) => QuanliBannerModel.fromSnaphot(document))
          .toList();
      return list;
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

  Future<List<QuanliBannerModel>> taiTatCaBanner() async {
    try {
      final result = await _db.collection("Banners").get();
      return result.docs
          .map((document) => QuanliBannerModel.fromSnaphot(document))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again";
    }
  }

  
  

  // Helper function to get ID from target screen
  String layIdTuManHinh(String manHinhDich) {
    // Remove leading slash and get first segment
    return manHinhDich.replaceFirst('/', '').split('/')[0];
  }

  // Create a new banner with image upload
  Future<void> taoBanner(QuanliBannerModel banner) async {
    try {
      // Generate ID from target screen
      final String maBanner = layIdTuManHinh(banner.manHinhDich);

      // Upload image if exists
      if (banner.tepAnh != null) {
        final storage = Get.find<TFirebaseStorageService>();
        banner.duongDanAnh = await storage.taiHinhAnhFile(
          'Banners/Images',
          banner.tepAnh!
        );
      }

      // Use the generated ID when creating document
      await _db.collection("Banners").doc(maBanner).set(banner.toJson());
      TLoaders.successSnackBar(
          title: "Thành công", message: "Banner đã được tạo thành công");
    } catch (e) {
      throw "Đã xảy ra lỗi. Vui lòng thử lại";
    }
  }

  // Update banner with image
  Future<void> capNhatBanner(String id, QuanliBannerModel banner) async {
    try {
      // Generate new ID if target screen changed
      final String maBanner = layIdTuManHinh(banner.manHinhDich);

      // If ID changed, delete old document and create new one
      if (id != maBanner) {
        await _db.collection("Banners").doc(id).delete();
      }

      // Upload new image if exists
      if (banner.tepAnh != null) {
        final storage = Get.find<TFirebaseStorageService>();
        banner.duongDanAnh = await storage.taiHinhAnhFile(
          'Banners/Images',
          banner.tepAnh!
        );
      }

      // Use new ID for update
      await _db.collection("Banners").doc(maBanner).set(banner.toJson());
      TLoaders.successSnackBar(
          title: "Thành công", message: "Banner đã được cập nhật thành công");
    } catch (e) {
      throw "Đã xảy ra lỗi. Vui lòng thử lại";
    }
  }

  // Delete banner
  Future<void> xoaBanner(String id) async {
    try {
      await _db.collection("Banners").doc(id).delete();
      TLoaders.successSnackBar(
          title: "Success", message: "Banner has been deleted successfully");
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again";
    }
  }
}
