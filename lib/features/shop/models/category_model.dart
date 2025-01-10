// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class QuanliDanhMucModel {
  String maDanhMuc;
  String tenDanhMuc;
  String hinhAnh;
  String maCapCha;
  bool noiBat;

  QuanliDanhMucModel({
    required this.maDanhMuc,
    required this.tenDanhMuc,
    required this.hinhAnh,
    this.maCapCha = "",
    required this.noiBat,
  });

  //Empty helper function
  static QuanliDanhMucModel empty() => QuanliDanhMucModel(
        maDanhMuc: "",
        tenDanhMuc: "",
        hinhAnh: "",
        noiBat: false,
      );

  //Convert model tojson
  Map<String, dynamic> toJson() {
    return {
      "Image": hinhAnh,
      "IsFeatured": noiBat,
      "Name": tenDanhMuc,
      "ParentId": maCapCha,
    };
  }

  //Map json oriented document snapshot from firebase to model
  factory QuanliDanhMucModel.fromSnaphot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return QuanliDanhMucModel(
        maDanhMuc: document.id,
        hinhAnh: data["Image"] ?? "",
        noiBat: data["IsFeatured"] ?? false,
        tenDanhMuc: data["Name"] ?? "",
        maCapCha: data["ParentId"] ?? "",
      );
    } else {
      return QuanliDanhMucModel.empty();
    }
  }
}
