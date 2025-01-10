import 'package:cloud_firestore/cloud_firestore.dart';

class QuanliDonHangModel {
  final String maDonHang;
  final String maNguoiDung;
  final List<DonHangItem> danhSachSanPham;
  final double tongTien;
  final Map<String, dynamic> diaChi;
  final String phuongThucThanhToan;
  final DateTime ngayDatHang;
  final DateTime ngayGiaoHang;
  final String trangThai;

  const QuanliDonHangModel({
    required this.maDonHang,
    required this.maNguoiDung,
    required this.danhSachSanPham,
    required this.tongTien,
    required this.diaChi,
    required this.phuongThucThanhToan,
    required this.ngayDatHang,
    required this.ngayGiaoHang,
    required this.trangThai,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': maDonHang,
      'userId': maNguoiDung,
      'items': danhSachSanPham.map((item) => item.toJson()).toList(),
      'totalAmount': tongTien,
      'address': diaChi,
      'paymentMethod': phuongThucThanhToan,
      'orderDate': ngayDatHang,
      'deliveryDate': ngayGiaoHang,
      'status': trangThai,
    };
  }

  factory QuanliDonHangModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return QuanliDonHangModel(
      maDonHang: data['id'] ?? '',
      maNguoiDung: data['userId'] ?? '',
      danhSachSanPham: (data['items'] as List<dynamic>)
          .map((item) => DonHangItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      tongTien: (data['totalAmount'] as num).toDouble(),
      diaChi: data['address'] as Map<String, dynamic>,
      phuongThucThanhToan: data['paymentMethod'] ?? '',
      ngayDatHang: (data['orderDate'] as Timestamp).toDate(),
      ngayGiaoHang: (data['deliveryDate'] as Timestamp).toDate(),
      trangThai: data['status'] ?? '',
    );
  }
}

class DonHangItem {
  final String maSanPham;
  final String tenSanPham;
  final String hinhAnh;
  final double gia;
  final int soLuong;
  final String? maBienThe;
  final Map<String, dynamic>? bienTheChon;
  final String tenThuongHieu;

  const DonHangItem({
    required this.maSanPham,
    required this.tenSanPham,
    required this.hinhAnh,
    required this.gia,
    required this.soLuong,
    this.maBienThe,
    this.bienTheChon,
    required this.tenThuongHieu,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': maSanPham,
      'title': tenSanPham,
      'image': hinhAnh,
      'price': gia,
      'quantity': soLuong,
      'variationId': maBienThe,
      'selectedVariation': bienTheChon,
      'brandName': tenThuongHieu,
    };
  }

  factory DonHangItem.fromMap(Map<String, dynamic> map) {
    return DonHangItem(
      maSanPham: map['productId'] ?? '',
      tenSanPham: map['title'] ?? '',
      hinhAnh: map['image'] ?? '',
      gia: (map['price'] as num).toDouble(),
      soLuong: map['quantity'] ?? 0,
      maBienThe: map['variationId'],
      bienTheChon: map['selectedVariation'],
      tenThuongHieu: map['brandName'] ?? '',
    );
  }
}
