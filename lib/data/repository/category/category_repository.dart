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
      throw "Đã xảy ra lỗi. Vui lòng thử lại";
    }
  } 

 

  

 
}
