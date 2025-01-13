import 'dart:ui';

import 'package:admin_panel/data/repository/order/order_repository.dart';
import 'package:admin_panel/features/shop/models/order_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:admin_panel/utils/helpers/pdf_helper.dart';
import 'package:flutter/material.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  
  final _orderRepository = Get.put(OrderRepository());
  final RxList<QuanliDonHangModel> orders = <QuanliDonHangModel>[].obs;
  final isLoading = false.obs;

  // Add new variables for search
  final searchController = TextEditingController();
  RxList<QuanliDonHangModel> filteredOrders = <QuanliDonHangModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    taiDonhang();
    filteredOrders.assignAll(orders);
  }

  Future<void> taiDonhang() async {
    try {
      isLoading.value = true;
      final allOrders = await _orderRepository.layTatCaDonHang();
      orders.assignAll(allOrders);
      filteredOrders.assignAll(orders);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> capNhatDonHangTonKho(String orderId, OrderStatus newStatus) async {
    try {
      isLoading.value = true;
      await _orderRepository.capNhatDonHangTonKho(orderId, newStatus);
      await taiDonhang();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> inChiTietDonHang(QuanliDonHangModel order) async {
    try {
      await PdfHelper.generateAndPrintOrderPdf(order);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể xuất PDF: ${e.toString()}',
      );
    }
  }

  Future<void> inDonHang() async {
    if (orders.isEmpty) {
      TLoaders.warningSnackBar(
        title: 'Thông báo',
        message: 'Không có đơn hàng để xuất',
      );
      return;
    }

    try {
      for (var order in orders) {
        await PdfHelper.generateAndPrintOrderPdf(order);
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể xuất PDF: ${e.toString()}',
      );
    }
  }

  // Add new method for search
  void searchOrders(String query) {
    if (query.isEmpty) {
      filteredOrders.assignAll(orders);
    } else {
      filteredOrders.assignAll(orders.where((order) {
        final String searchQuery = query.toLowerCase();
        return order.maDonHang.toLowerCase().contains(searchQuery);
      }));
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
