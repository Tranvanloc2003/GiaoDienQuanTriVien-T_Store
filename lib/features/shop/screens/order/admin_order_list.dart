import 'package:admin_panel/data/repository/order/order_repository.dart';
import 'package:admin_panel/features/shop/controllers/order_controller.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminOrderList extends StatelessWidget {
  const AdminOrderList({Key? key}) : super(key: key);

  Color getStatusColor(String status) {
    switch (status) {
      case 'xacNhanDon':
        return Colors.blue;
      case 'dangGiao':
        return Colors.orange;
      case 'daGiao':
        return Colors.green;
      case 'daHuy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo repository trước khi khởi tạo controller
    Get.put(OrderRepository());
    final controller = Get.put(OrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => controller.inDonHang(),
            tooltip: 'Xuất PDF',
          ),
        ],
      ),
      body: Obx(
        () => controller.orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Không có đơn hàng nào',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final donHang = controller.orders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue.withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.transparent,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          title: Row(
                            children: [
                              const Icon(Icons.receipt_long, color: Colors.blue),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đơn hàng #${donHang.maDonHang}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(donHang.trangThai).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: getStatusColor(donHang.trangThai),
                                      ),
                                    ),
                                    child: Text(
                                      donHang.trangThai,
                                      style: TextStyle(
                                        color: getStatusColor(donHang.trangThai),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  const SizedBox(height: 12),
                                  ...donHang.danhSachSanPham.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.shopping_bag_outlined, 
                                          size: 20, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.tenSanPham,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'x${item.soLuong}',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.print),
                                        label: const Text('Xuất PDF'),
                                        onPressed: () => controller.inChiTietDonHang(donHang),
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'vi_VN',
                                          symbol: '₫',
                                        ).format(donHang.tongTien),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.update, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Cập nhật trạng thái:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                          ),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              canvasColor: Colors.white,
                                            ),
                                            child: DropdownButton<OrderStatus>(
                                              isExpanded: true,
                                              value: OrderStatus.values.firstWhere(
                                                (e) => e.toString().split('.').last ==
                                                    donHang.trangThai.split('.').last,
                                                orElse: () => OrderStatus.xacNhanDon,
                                              ),
                                              underline: Container(),
                                              items: OrderStatus.values.map((trangThai) {
                                                return DropdownMenuItem(
                                                  value: trangThai,
                                                  child: Text(
                                                    trangThai.toString().split('.').last,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (trangThaiMoi) {
                                                if (trangThaiMoi != null) {
                                                  controller.capNhatDonHangTonKho(
                                                    donHang.maDonHang,
                                                    trangThaiMoi,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
