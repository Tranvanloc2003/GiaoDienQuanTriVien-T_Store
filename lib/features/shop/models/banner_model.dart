import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
class QuanliBannerModel {
  final String maBanner;
  String duongDanAnh;
  final String manHinhDich;
  final bool hoatDong;
  XFile? tepAnh;

  QuanliBannerModel({
    required this.maBanner,
    required this.duongDanAnh,
    required this.manHinhDich,
    required this.hoatDong,
    this.tepAnh,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ImageUrl': duongDanAnh,
      'TargetScreen': manHinhDich,
      'Active': hoatDong,
    };
  }

  factory QuanliBannerModel.fromSnaphot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return QuanliBannerModel(
      maBanner: snapshot.id,
      duongDanAnh: data['ImageUrl'] ?? "",
      manHinhDich: data['TargetScreen'] ?? "",
      hoatDong: data['Active'] ?? false,
    );
  }
}
