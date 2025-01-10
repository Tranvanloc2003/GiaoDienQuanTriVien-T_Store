import 'dart:typed_data';

import 'package:admin_panel/data/repository/order/order_repository.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:admin_panel/utils/helpers/pdf_helper.dart';

class RevenueController extends GetxController {
  static RevenueController get instance => Get.find();

  final _orderRepository = Get.put(OrderRepository());
  

  final selectedDailyDate = DateTime.now().obs;
  final selectedMonthDate = DateTime.now().obs;
  final selectedYear = DateTime.now().year.obs;
  

  final dailyRevenue = <String, double>{}.obs;
  final monthlyRevenue = <String, double>{}.obs;
  final yearlyRevenue = <String, double>{}.obs;
  
  final isLoadingDaily = false.obs;
  final isLoadingMonthly = false.obs;
  final isLoadingYearly = false.obs;

  Future<void> taiDoanhThuNgay() async {
    try {
      isLoadingDaily.value = true;
      dailyRevenue.value = await _orderRepository.layDoanhThuNgay(selectedDailyDate.value);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoadingDaily.value = false;
    }
  }

  Future<void> taiDoanhThuThang() async {
    try {
      isLoadingMonthly.value = true;
      monthlyRevenue.value = await _orderRepository.layDoanhThuThang(selectedMonthDate.value);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoadingMonthly.value = false;
    }
  }

  Future<void> taiDoanhThuNam() async {
    try {
      isLoadingYearly.value = true;
      yearlyRevenue.value = await _orderRepository.layDoanhThuNam(selectedYear.value);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoadingYearly.value = false;
    }
  }

  void thayDoiNgay(DateTime date) {
    selectedDailyDate.value = date;
    taiDoanhThuNgay();
  }

  void thayDoiThang(DateTime date) {
    selectedMonthDate.value = date;
    taiDoanhThuThang();
  }

  void thayDoiNam(int year) {
    selectedYear.value = year;
    taiDoanhThuNam();
  }

  Future<void> xuatBaoCaoNgay() async {
    try {
      isLoadingDaily.value = true;

      // Lấy dữ liệu doanh thu chi tiết theo ngày trong tháng
      final dailyData = await _orderRepository.layDoanhThuChiTietTheoNgay(selectedDailyDate.value);
      
      // Tính tổng doanh thu
      final totalRevenue = dailyData.values.fold(0.0, (sum, value) => sum + value);

      print('Chi tiết doanh thu theo ngày: $dailyData'); // Debug print
      print('Tổng doanh thu: $totalRevenue'); // Debug print

      await PdfHelper.generateRevenueReport(
        date: selectedDailyDate.value,
        period: DateFormat('MM/yyyy').format(selectedDailyDate.value),
        revenue: totalRevenue,
        title: 'Báo cáo doanh thu tháng ${DateFormat('MM/yyyy').format(selectedDailyDate.value)}',
        dailyData: dailyData,
        isDaily: true,
      );

      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đã xuất báo cáo PDF thành công',
      );
    } catch (e) {
      print('Lỗi xuất báo cáo: $e'); // Debug print
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể xuất báo cáo: ${e.toString()}',
      );
    } finally {
      isLoadingDaily.value = false;
    }
  }

  Future<void> xuatBaoCaoThang() async {
    try {
      isLoadingMonthly.value = true;
      
      final monthData = getMonthlyRevenueMap();
      final totalRevenue = monthData.values.fold(0.0, (sum, value) => sum + value);

      await PdfHelper.generateRevenueReport(
        date: selectedMonthDate.value,
        period: DateFormat('MM/yyyy').format(selectedMonthDate.value),
        revenue: totalRevenue,
        title: 'Báo cáo doanh thu tháng ${DateFormat('MM/yyyy').format(selectedMonthDate.value)}',
        dailyData: monthData,
      );

      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đã xuất báo cáo PDF',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể xuất báo cáo: ${e.toString()}',
      );
    } finally {
      isLoadingMonthly.value = false;
    }
  }

  Future<void> xuatBaoCaoNam() async {
    try {
      isLoadingYearly.value = true;
      
      // Lấy dữ liệu doanh thu chi tiết theo tháng
      final monthlyData = await _orderRepository.layDoanhThuChiTietTheoThang(selectedYear.value);
      
      // Tính tổng doanh thu năm
      final totalRevenue = monthlyData.values.fold(0.0, (sum, value) => sum + value);

      print('Chi tiết doanh thu theo tháng: $monthlyData'); // Debug print
      print('Tổng doanh thu năm: $totalRevenue'); // Debug print

      await PdfHelper.generateRevenueReport(
        date: DateTime(selectedYear.value),
        period: selectedYear.value.toString(),
        revenue: totalRevenue,
        title: 'Báo cáo doanh thu năm ${selectedYear.value}',
        dailyData: monthlyData, // Sử dụng monthlyData thay vì yearData
        isDaily: false,
      );

      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đã xuất báo cáo PDF thành công',
      );
    } catch (e) {
      print('Lỗi xuất báo cáo năm: $e'); // Debug print
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể xuất báo cáo: ${e.toString()}',
      );
    } finally {
      isLoadingYearly.value = false;
    }
  }

  Map<int, double> getDailyRevenueMap() {
    Map<int, double> dailyMap = {};
    final daysInMonth = DateTime(
      selectedMonthDate.value.year,
      selectedMonthDate.value.month + 1,
      0,
    ).day;

    // Initialize all days with 0
    for (int i = 1; i <= daysInMonth; i++) {
      dailyMap[i] = 0.0;
    }

    // Fill in actual revenue data
    dailyRevenue.forEach((key, value) {
      final day = DateTime.parse(key).day;
      dailyMap[day] = value;
    });

    return dailyMap;
  }

  Map<int, double> getMonthlyRevenueMap() {
    Map<int, double> monthlyMap = {};

    // Initialize all months with 0
    for (int i = 1; i <= 12; i++) {
      monthlyMap[i] = 0.0;
    }

    // Fill in actual revenue data
    monthlyRevenue.forEach((key, value) {
      final month = DateTime.parse(key).month;
      monthlyMap[month] = value;
    });

    return monthlyMap;
  }
}