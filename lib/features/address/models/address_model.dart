// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:admin_panel/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiaChiModel {
  String id;
  final String hoTen;
  final String soDienThoai; 
  final String duong;
  final String datNuoc;
  final String tinh;
  final DateTime? thoiGian;

  DiaChiModel({
    required this.id,
    required this.hoTen,
    required this.soDienThoai,
    required this.duong,
    required this.datNuoc,
    required this.tinh,
    this.thoiGian,
  });

  static DiaChiModel empty() => DiaChiModel(
    id: "",
    hoTen: "",
    soDienThoai: "",
    duong: "",
    datNuoc: "",
    tinh: "",
  );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': hoTen,
      'PhoneNumber': soDienThoai,
      'Street': duong,
      'Country': datNuoc,
      'City': tinh,
      'DateTime': DateTime.now(),
    };
  }

  factory DiaChiModel.fromMap(Map<String, dynamic> data) {
    return DiaChiModel(
      id: data['Id'] as String,
      hoTen: data['Name'] as String,
      soDienThoai: data['PhoneNumber'] as String,
      duong: data['Street'] as String,
      datNuoc: data['Country'] as String,
      tinh: data['City'] as String,
      thoiGian: (data['DateTime'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return "$hoTen, $soDienThoai, $duong";
  }
  
}