import 'package:admin_panel/data/repository/authentication/authentication_repository.dart';
import 'package:admin_panel/features/address/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<DiaChiModel>> layDiaChiNguoiDung() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw "Không thể tìm thấy thông tin người dùng.";
      }

      final result = await _db
          .collection("NguoiDung")
          .doc(userId)
          .collection("DiaChi")
          .get();

      return result.docs.map((doc) => DiaChiModel(
        id: doc.id,
        hoTen: doc['Name'] ?? '',
        soDienThoai: doc['PhoneNumber'] ?? '',
        duong: doc['Street'] ?? '',
        datNuoc: doc['Country'] ?? '',
        tinh: doc['Province'] ?? '',
        thoiGian: doc['DateTime'] != null 
            ? (doc['DateTime'] as Timestamp).toDate()
            : DateTime.now(),
      )).toList();
    } catch (e) {
      throw "Lỗi khi lấy thông tin địa chỉ: $e";
    }
  }

  Future<void> luuDiaChi(DiaChiModel diaChi) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw "Không tìm thấy thông tin người dùng.";

      await _db
          .collection("NguoiDung")
          .doc(userId)
          .collection("DiaChi")
          .doc(diaChi.id)
          .set({
        'Name': diaChi.hoTen,
        'PhoneNumber': diaChi.soDienThoai,
        'Street': diaChi.duong,
        'Country': diaChi.datNuoc,
        'City': diaChi.tinh,
        'DateTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw "Không thể lưu địa chỉ: $e";
    }
  }

  Future<DiaChiModel?> layDiaChiMacDinh(String userId) async {
    try {
      final snapshot = await _db
          .collection("NguoiDung")
          .doc(userId)
          .collection("DiaChi")
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return DiaChiModel(
          id: doc.id,
          hoTen: doc['Name'] ?? '',
          soDienThoai: doc['PhoneNumber'] ?? '',
          duong: doc['Street'] ?? '',
          datNuoc: doc['Country'] ?? '',
          tinh: doc['City'] ?? '',
          thoiGian: doc['DateTime'] != null 
              ? (doc['DateTime'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw "Lỗi khi lấy địa chỉ mặc định: $e";
    }
  }
}