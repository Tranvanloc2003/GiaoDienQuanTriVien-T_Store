import 'dart:io';

import 'package:admin_panel/data/repository/authentication/authentication_repository.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Create user
  Future<void> taoNguoiDung(UserModel user) async {
    try {
      await _db.collection("NguoiDung").doc(user.maNguoiDung).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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

  // Get admin details
  Future<UserModel> taiChiTietAdmin() async {
    try {
      final docSnapshot = await _db
          .collection("NguoiDung")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      
      if (!docSnapshot.exists) {
        throw 'No user details found';
      }
      
      return UserModel.fromSnapshot(docSnapshot);
    } catch (e) {
      throw "Error fetching admin details: $e"; 
    }
  }

  // Sửa lại phương thức layTatCaNguoiDung
  Future<List<UserModel>> layTatCaNguoiDung() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("NguoiDung")
          .get();

      if (snapshot.docs.isEmpty) {
        print('Không tìm thấy người dùng trong database');
        return [];
      }

      final users = snapshot.docs.map((doc) {
        try {
          return UserModel.fromSnapshot(doc);
        } catch (e) {
          print('Lỗi parse document người dùng: ${doc.id}, Lỗi: $e');
          return null;
        }
      }).whereType<UserModel>().toList();

      print('Đã lấy thành công ${users.length} người dùng');
      return users;

    } catch (e) {
      print('Lỗi trong layTatCaNguoiDung: $e');
      throw 'Lỗi khi lấy danh sách người dùng: $e';
    }
  }

  // Thêm phương thức này để lấy thông tin user theo ID
  Future<UserModel> layNguoiDungTheoId(String userId) async {
    try {
      final documentSnapshot = await _db.collection("NguoiDung").doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
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

  // Update user
  Future<void> capNhatNguoiDung(UserModel user) async {
    try {
      await _db.collection("NguoiDung").doc(user.maNguoiDung).update(user.toJson());
    } catch (e) {
      throw "Error updating user: $e";
    }
  }

  // Delete user
  Future<void> xoaNguoiDung(String userId) async {
    try {
      await _db.collection("NguoiDung").doc(userId).delete();
    } catch (e) {
      throw "Error deleting user: $e";
    }
  }
   //Upload any image
  Future<String> taiHinhAnh(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
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
    //Update a field in specific user collection
  Future<void> capNhatTruongDon(Map<String, dynamic> json) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null) throw 'Không tìm thấy người dùng';

      await _db.collection("NguoiDung").doc(userId).update(json);
      
      // Thêm dòng này để cập nhật thời gian
      await _db.collection("NguoiDung").doc(userId).update({
        'UpdatedAt': FieldValue.serverTimestamp(),
      });
      
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
  //Save user data to firetore
  Future<void> luuHoSoNguoiDung(UserModel user) async {
    try {
      final userData = user.toJson();
      // Add timestamps
      userData['CreatedAt'] = FieldValue.serverTimestamp();
      userData['UpdatedAt'] = FieldValue.serverTimestamp();
      
      await _db.collection("NguoiDung").doc(user.maNguoiDung).set(userData);
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
}