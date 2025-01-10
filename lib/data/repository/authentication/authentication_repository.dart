import 'package:admin_panel/features/authentication/screens/login/login.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

//get autentication user data
  User? get authUser => _auth.currentUser;

//get IsAuthenticated user
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    _auth.setPersistence(Persistence.LOCAL);
    super.onReady();
  }

  Future<bool> nguoiDungAdmin(String uid) async {
    try {
      final userDoc = await _db.collection("NguoiDung").doc(uid).get();
      if (!userDoc.exists) return false;
      
      final userData = userDoc.data();
      // Sửa lại cách kiểm tra role
      return userData?['Role'] == "admin"; // Kiểm tra role là string "admin"
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  //function to determine the relevant screen and redirect accordingly
  void screenRedirect() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Kiểm tra role trực tiếp từ Firestore thay vì gọi nguoiDungAdmin
        final userDoc = await _db.collection("NguoiDung").doc(user.uid).get();
        if (!userDoc.exists) {
          await _auth.signOut();
          Get.offAllNamed(Routes.login);
          return;
        }

        final role = userDoc.data()?['Role']?.toString().toLowerCase();
        if (role == "admin") {
          Get.offAllNamed(Routes.dashboard);
        } else {
          await _auth.signOut();
          Get.offAllNamed(Routes.login);
        }
      } else {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      print("Error in screenRedirect: $e");
      Get.offAllNamed(Routes.login);
    }
  }

// LOGIN
  Future<UserCredential> dangNhap(
      String email, String password) async {
    try {
      if (email.isEmpty) throw 'Email không được để trống';
      if (password.isEmpty) throw 'Mật khẩu không được để trống';

      // First authenticate the user
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      
      // Kiểm tra role từ Firestore
      final userDoc = await _db.collection("NguoiDung").doc(credential.user!.uid).get();
      if (!userDoc.exists) {
        await _auth.signOut();
        throw 'Không tìm thấy thông tin người dùng';
      }

      final role = userDoc.data()?['Role']?.toString().toLowerCase();
      if (role != "admin") {
        await _auth.signOut();
        throw 'Không có quyền truy cập. Chỉ Admin mới được phép đăng nhập.';
      }

      return credential;

    } catch (e) {
      if (e is String) throw e;
      if (e is FirebaseAuthException) throw TFirebaseAuthException(e.code).message;
      if (e is FirebaseException) throw TFirebaseException(e.code).message;
      if (e is FormatException) throw const TFormatException();
      if (e is PlatformException) throw TPlatformException(e.code).message;
      throw "Đã có lỗi xảy ra: $e";
    }
  }

// REGISTER
  Future<UserCredential> dangKi(
      String email, String password) async {
    try {
      return _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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



 Future<void> dangXuat() async {
    try {
     
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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
// DELETE USER


// CREATE Admin User
Future<UserCredential> taoTaiKhoanAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      // Cập nhật lại cách lưu role
      await _db.collection("NguoiDung").doc(credential.user!.uid).set({
        'Email': email,
        'FirstName': 'Loc', 
        'LastName': 'Admin',
        'PhoneNumber': '',
        'ProfilePicture': '',
        'Role': "admin", // Lưu role dưới dạng string
        'UserName': '',
        'CreatedAt': FieldValue.serverTimestamp(),
        'UpdatedAt': FieldValue.serverTimestamp(),
      });
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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
