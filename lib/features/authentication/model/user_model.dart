import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? maNguoiDung;
  String ho;
  String ten; 
  String tenNguoiDung;
  String email;
  String soDienThoai;
  String anhDaiDien;
  AppRole vaiTro;
  DateTime? thoiGianTao;
  DateTime? thoiGianCapNhat;

  // Constructor for UserModel
  UserModel({
    this.maNguoiDung,
    this.email = '',
    this.ho = '',
    this.ten = '',
    this.tenNguoiDung = '',
    this.soDienThoai = '',
    this.anhDaiDien = '',
    this.vaiTro = AppRole.user,
    this.thoiGianTao,
    this.thoiGianCapNhat,
  });

  // Helper methods
  String get fullName => '$ho $ten';
  String get formattedDate => TFormatter.formatDate(thoiGianTao);
  String get formattedUpdatedDate => TFormatter.formatDate(thoiGianCapNhat);
  String get formattedPhoneNumber => TFormatter.formatPhoneNumber(soDienThoai);

  // Static function to create an empty user model
  static UserModel empty() => UserModel(email: '');

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() => {
    'FirstName': ho,
    'LastName': ten,
    'UserName': tenNguoiDung,
    'Email': email,
    'PhoneNumber': soDienThoai,
    'ProfilePicture': anhDaiDien,
    'Role': vaiTro.name.toString(),
    'CreatedAt': thoiGianTao,
    'UpdatedAt': thoiGianCapNhat = DateTime.now(),
  };

  /// Factory method to create a UserModel from a Firebase document snapshot.
factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  if (document.data() != null) {
    final data = document.data()!;
    
    // Sửa lại cách parse role
    AppRole parseRole(String? roleStr) {
      if (roleStr?.toLowerCase() == "admin") {
        return AppRole.admin;
      }
      return AppRole.user;
    }

    return UserModel(
      maNguoiDung: document.id,
      ho: data['FirstName']?.toString() ?? '',
      ten: data['LastName']?.toString() ?? '',
      tenNguoiDung: data['UserName']?.toString() ?? '',
      email: data['Email']?.toString() ?? '',
      soDienThoai: data['PhoneNumber']?.toString() ?? '',
      anhDaiDien: data['ProfilePicture']?.toString() ?? '',
      vaiTro: parseRole(data['Role']?.toString()),
      thoiGianTao: (data['CreatedAt'] as Timestamp?)?.toDate(),
      thoiGianCapNhat: (data['UpdatedAt'] as Timestamp?)?.toDate(),
    );
  }
  return empty();
}
}