import 'package:admin_panel/data/services/firebase_storage_service.dart';
import 'package:admin_panel/features/shop/models/category_model.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  //Getall categories
  Future<List<QuanliDanhMucModel>> layTatCaDanhMuc() async {
    try {
      final snapshot = await _db.collection("DanhMuc").get();
      final list = snapshot.docs
          .map((document) => QuanliDanhMucModel.fromSnaphot(document))
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

  // Create new category
  Future<void> taoDanhMuc(QuanliDanhMucModel category) async {
    try {
      TFullScreenLoader.openLoadingDialog('Creating category...', TImages.docerAnimation);
      
      // Upload image first
      final storage = Get.put(TFirebaseStorageService());
      final file = await storage.getImageDataFromAssets(category.hinhAnh);
      final url = await storage.taiHinhAnhData('Categories', file, category.hinhAnh);

      // Prepare data according to Firebase structure
      final categoryData = {
        'Image': url,
        'IsFeatured': category.noiBat,
        'Name': category.tenDanhMuc,
        'ParentId': category.maCapCha,
      };

      // Create document in Firestore
      await _db.collection('Categories').doc().set(categoryData);
      
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Success', message: 'Category created successfully!');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      throw 'Something went wrong. Please try again';
    }
  }

  // Update category
  Future<void> capNhatDanhMuc(String categoryId, Map<String, dynamic> data) async {
    try {
      TFullScreenLoader.openLoadingDialog('Updating category...', TImages.docerAnimation);

      // If there's a new image to upload
      if (data['Image'] != null && !data['Image'].toString().startsWith('http')) {
        final storage = Get.put(TFirebaseStorageService());
        final file = await storage.getImageDataFromAssets(data['Image']);
        final url = await storage.taiHinhAnhData('Categories', file, data['Name']);
        data['Image'] = url;
      }

      await _db.collection('Categories').doc(categoryId).update({
        if (data['Name'] != null) 'Name': data['Name'],
        if (data['Image'] != null) 'Image': data['Image'],
        if (data['IsFeatured'] != null) 'IsFeatured': data['IsFeatured'],
        if (data['ParentId'] != null) 'ParentId': data['ParentId'],
      });

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Success', message: 'Category updated successfully!');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete category
  Future<void> xoaDanhMuc(String categoryId) async {
    try {
      TFullScreenLoader.openLoadingDialog('Deleting category...', TImages.docerAnimation);
      await _db.collection('Categories').doc(categoryId).delete();
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Success', message: 'Category deleted successfully!');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      throw 'Something went wrong. Please try again';
    }
  }
}
