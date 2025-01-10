import 'package:admin_panel/features/shop/models/order_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderRepository extends GetxController {
  final _db = FirebaseFirestore.instance;


  Future<Map<String, double>> layDoanhThuNgay(DateTime ngay) async {
    try {
      final ngayBatDau = DateTime(ngay.year, ngay.month, ngay.day);
      final ngayKetThuc = ngayBatDau.add(const Duration(days: 1));

      final dsNguoiDung = await _db.collection("NguoiDung").get();
      double tongDoanhThu = 0;
      
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('orderDate', isGreaterThanOrEqualTo: ngayBatDau)
            .where('orderDate', isLessThanOrEqualTo: ngayKetThuc)
            .get();

        for (var donHang in dsDonHang.docs) {
          final order = QuanliDonHangModel.fromSnapshot(donHang);
          if (order.trangThai == 'OrderStatus.daGiaoHang') {
            tongDoanhThu += order.tongTien;
          }
        }
      }

      return {ngayBatDau.toString(): tongDoanhThu};
    } catch (e) {
      throw 'Không thể tính doanh thu: $e';
    }
  }

  Future<Map<String, double>> layDoanhThuThang(DateTime thang) async {
    try {
      final ngayDauThang = DateTime(thang.year, thang.month, 1);
      final ngayCuoiThang = DateTime(thang.year, thang.month + 1, 0);

      final dsNguoiDung = await _db.collection("NguoiDung").get();
      double tongDoanhThu = 0;
      
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('orderDate', isGreaterThanOrEqualTo: ngayDauThang)
            .where('orderDate', isLessThanOrEqualTo: ngayCuoiThang)
            .get();

        for (var donHang in dsDonHang.docs) {
          final order = QuanliDonHangModel.fromSnapshot(donHang);
          if ( order.trangThai == 'OrderStatus.daGiaoHang') {
            tongDoanhThu += order.tongTien;
          }
        }
      }

      return {ngayDauThang.toString(): tongDoanhThu};
    } catch (e) {
      throw 'Không thể tính doanh thu tháng: $e';
    }
  }

  Future<Map<String, double>> layDoanhThuNam(int nam) async {
    try {
      final ngayDauNam = DateTime(nam, 1, 1);
      final ngayCuoiNam = DateTime(nam, 12, 31, 23, 59, 59);

      final dsNguoiDung = await _db.collection("NguoiDung").get();
      double tongDoanhThu = 0;
      
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('orderDate', isGreaterThanOrEqualTo: ngayDauNam)
            .where('orderDate', isLessThanOrEqualTo: ngayCuoiNam)
            .get();

        for (var donHang in dsDonHang.docs) {
          final order = QuanliDonHangModel.fromSnapshot(donHang);
          if (order.trangThai == 'OrderStatus.daGiaoHang') {
            tongDoanhThu += order.tongTien;
          }
        }
      }

      return {ngayDauNam.toString(): tongDoanhThu};
    } catch (e) {
      throw 'Không thể tính doanh thu năm: $e';
    }
  }

  Future<void> capNhatDonHangTonKho(String maDonHang, OrderStatus trangThaiMoi) async {
    try {
      final dsNguoiDung = await _db.collection("NguoiDung").get();
      
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('id', isEqualTo: maDonHang)
            .limit(1) 
            .get();

        if (dsDonHang.docs.isNotEmpty) {
          await dsDonHang.docs.first.reference.update({
            'status': trangThaiMoi.toString(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
          return; 
        }
      }
      throw 'Không tìm thấy đơn hàng';
    } catch (e) {
      throw 'Không thể cập nhật trạng thái đơn hàng: $e';
    }
  }

  Future<List<QuanliDonHangModel>> layTatCaDonHang() async {
    try {
      final List<QuanliDonHangModel> dsDonHang = [];
      final dsNguoiDung = await _db.collection("NguoiDung").get();
      
      for (var nguoiDung in dsNguoiDung.docs) {
        final donHangSnapshot = await nguoiDung.reference
            .collection("DonHang")
            .get();

        final donHangNguoiDung = donHangSnapshot.docs
            .map((doc) => QuanliDonHangModel.fromSnapshot(doc))
            .toList();
        dsDonHang.addAll(donHangNguoiDung);
      }
      
      return dsDonHang;
    } catch (e) {
      throw 'Không thể lấy danh sách đơn hàng: $e';
    }
  }

  Future<Map<String, double>> layDoanhThuTheoNgayTrongNam(int nam) async {
    try {
      final ngayDauNam = DateTime(nam, 1, 1);
      final ngayCuoiNam = DateTime(nam, 12, 31, 23, 59, 59);
      final Map<String, double> doanhThuTheoNgay = {};

      final dsNguoiDung = await _db.collection("NguoiDung").get();
      
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('orderDate', isGreaterThanOrEqualTo: ngayDauNam)
            .where('orderDate', isLessThanOrEqualTo: ngayCuoiNam)
            .get();

        for (var donHang in dsDonHang.docs) {
          final order = QuanliDonHangModel.fromSnapshot(donHang);
          if (order.trangThai == 'OrderStatus.daGiaoHang') {
            // Lấy ngày từ timestamp
            final ngayDonHang = DateTime.fromMillisecondsSinceEpoch(
              order.ngayDatHang.millisecondsSinceEpoch
            );
            final ngayKey = DateFormat('dd/MM/yyyy').format(ngayDonHang);
            
            // Cộng dồn doanh thu theo ngày
            doanhThuTheoNgay[ngayKey] = (doanhThuTheoNgay[ngayKey] ?? 0) + order.tongTien;
          }
        }
      }

      return doanhThuTheoNgay;
    } catch (e) {
      throw 'Không thể lấy doanh thu theo ngày: $e';
    }
  }

  Future<Map<int, double>> layDoanhThuChiTietTheoNgay(DateTime thang) async {
    try {
      final ngayDauThang = DateTime(thang.year, thang.month, 1);
      final ngayCuoiThang = DateTime(thang.year, thang.month + 1, 0);
      
      // Map lưu doanh thu theo ngày
      Map<int, double> doanhThuTheoNgay = {};
      
      final dsNguoiDung = await _db.collection("NguoiDung").get();
      
      // Khởi tạo tất cả các ngày trong tháng với giá trị 0
      for (int i = 1; i <= ngayCuoiThang.day; i++) {
        doanhThuTheoNgay[i] = 0.0;
      }
      
      // Lấy dữ liệu từ Firebase
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('orderDate', isGreaterThanOrEqualTo: ngayDauThang)
            .where('orderDate', isLessThanOrEqualTo: ngayCuoiThang)
            .get();

        // Tính tổng doanh thu cho từng ngày
        for (var donHang in dsDonHang.docs) {
          final order = QuanliDonHangModel.fromSnapshot(donHang);
          if (order.trangThai == 'OrderStatus.daGiaoHang') {
            final ngayDonHang = DateTime.fromMillisecondsSinceEpoch(
              order.ngayDatHang.millisecondsSinceEpoch
            );
            // Cộng dồn vào ngày tương ứng
            doanhThuTheoNgay[ngayDonHang.day] = 
                (doanhThuTheoNgay[ngayDonHang.day] ?? 0) + order.tongTien;
          }
        }
      }

      print('Doanh thu theo ngày: $doanhThuTheoNgay'); // Debug print
      return doanhThuTheoNgay;
    } catch (e) {
      print('Lỗi lấy doanh thu theo ngày: $e'); // Debug print
      throw 'Không thể lấy doanh thu theo ngày: $e';
    }
  }

  Future<Map<int, double>> layDoanhThuChiTietTheoThang(int nam) async {
    try {
      final ngayDauNam = DateTime(nam, 1, 1);
      final ngayCuoiNam = DateTime(nam, 12, 31, 23, 59, 59);
      
      // Map lưu doanh thu theo tháng
      Map<int, double> doanhThuTheoThang = {};
      
      // Khởi tạo tất cả các tháng với giá trị 0
      for (int i = 1; i <= 12; i++) {
        doanhThuTheoThang[i] = 0.0;
      }

      final dsNguoiDung = await _db.collection("NguoiDung").get();
      
      // Lấy dữ liệu từ Firebase
      for (var nguoiDung in dsNguoiDung.docs) {
        final dsDonHang = await nguoiDung.reference
            .collection("DonHang")
            .where('orderDate', isGreaterThanOrEqualTo: ngayDauNam)
            .where('orderDate', isLessThanOrEqualTo: ngayCuoiNam)
            .get();

        // Tính tổng doanh thu cho từng tháng
        for (var donHang in dsDonHang.docs) {
          final order = QuanliDonHangModel.fromSnapshot(donHang);
          if (order.trangThai == 'OrderStatus.daGiaoHang') {
            final thangDonHang = DateTime.fromMillisecondsSinceEpoch(
              order.ngayDatHang.millisecondsSinceEpoch
            ).month;
            // Cộng dồn vào tháng tương ứng
            doanhThuTheoThang[thangDonHang] = 
                (doanhThuTheoThang[thangDonHang] ?? 0) + order.tongTien;
          }
        }
      }

      print('Doanh thu theo tháng: $doanhThuTheoThang'); // Debug print
      return doanhThuTheoThang;
    } catch (e) {
      print('Lỗi lấy doanh thu theo tháng: $e'); // Debug print
      throw 'Không thể lấy doanh thu theo tháng: $e';
    }
  }
}