import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class ProductDataSource extends DataTableSource {
  final RxList<QuanliSanPhamModel> danhSachSanPham;
  final BuildContext context;
  final Function(QuanliSanPhamModel) onEdit;
  final Function(QuanliSanPhamModel) onDelete;

  ProductDataSource(this.danhSachSanPham, this.context, {
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow getRow(int index) {
    final sanPham = danhSachSanPham[index];
    return DataRow2(
      cells: [
        DataCell(
          Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: sanPham.danhSachAnh?.toString() ?? '',
              fit: BoxFit.cover,
              memCacheWidth: 200,
              placeholder: (context, url) => Container(
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[50],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported_outlined, 
                      color: Colors.grey[400],
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No Image',
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        DataCell(Text(sanPham.tenSanPham)),
        DataCell(Text('\$${sanPham.gia.toStringAsFixed(2)}')),
        DataCell(Text('${sanPham.tonKho}')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(sanPham),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(sanPham),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => danhSachSanPham.length;

  @override
  int get selectedRowCount => 0;
}
