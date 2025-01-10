import 'package:admin_panel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:admin_panel/data/repository/product/product_repository.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductTabletScreen extends StatelessWidget {
  const ProductTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductRepository());
    final ScrollController scrollController = ScrollController();

    return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Products Management'),
  //       actions: [
  //         ElevatedButton.icon(
  //           onPressed: () =>Get.toNamed(Routes.taoSanPham),
  //           icon: const Icon(Icons.add),
  //           label: const Text('Add Product'),
  //         ),
  //       ],
  //     ),
  //     body: FutureBuilder<List<QuanliSanPhamModel>>(
  //       future: controller.laySanPhamNoiBat(limit: -1),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         }

  //         final products = snapshot.data ?? [];

  //         return Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Card(
  //             child: DataTable2(
  //               scrollController: scrollController,
  //               columns: const [
  //                 DataColumn2(
  //                   label: Text('Thumbnail'),
  //                   size: ColumnSize.S,
  //                 ),
  //                 DataColumn2(
  //                   label: Text('Title'),
  //                   size: ColumnSize.L,
  //                 ),
  //                 DataColumn2(
  //                   label: Text('Price'),
  //                   size: ColumnSize.M,
  //                   numeric: true,
  //                 ),
  //                 DataColumn2(
  //                   label: Text('Actions'),
  //                   size: ColumnSize.S,
  //                 ),
  //               ],
  //               rows: products.map((product) {
  //                 return DataRow2(
  //                   cells: [
  //                     DataCell(
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.circular(8),
  //                         child: Container(
  //                           width: 40,
  //                           height: 40,
  //                           decoration: BoxDecoration(
  //                             color: Colors.grey[100],
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: product.thumbnail.isNotEmpty
  //                               ? CachedNetworkImage(
  //                                   imageUrl: product.thumbnail,
  //                                   fit: BoxFit.cover,
  //                                   placeholder: (context, url) => const Center(
  //                                     child: CircularProgressIndicator(
  //                                       strokeWidth: 2,
  //                                     ),
  //                                   ),
  //                                   errorWidget: (context, url, error) => const Center(
  //                                     child: Icon(
  //                                       Icons.image_not_supported,
  //                                       color: Colors.grey,
  //                                     ),
  //                                   ),
  //                                 )
  //                               : const Center(
  //                                   child: Icon(
  //                                     Icons.image_not_supported,
  //                                     color: Colors.grey,
  //                                   ),
  //                                 ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       Tooltip(
  //                         message: product.title,
  //                         child: Text(
  //                           product.title,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
  //                     DataCell(Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         IconButton(
  //                           icon: const Icon(Icons.edit, color: Colors.blue),
  //                           onPressed: () => _showEditProductDialog(context, product),
  //                           tooltip: 'Edit',
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(Icons.delete, color: Colors.red),
  //                           onPressed: () => _showDeleteConfirmation(context, product),
  //                           tooltip: 'Delete',
  //                         ),
  //                       ],
  //                     )),
  //                   ],
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // void _showAddProductDialog(BuildContext context) {
  //   Get.toNamed(Routes.taoSanPham);
  // }

  // void _showEditProductDialog(BuildContext context, QuanliSanPhamModel product) {
  //   // Implement edit product dialog
  // }

  // void _showDeleteConfirmation(BuildContext context, QuanliSanPhamModel product) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Product'),
  //       content: Text('Are you sure you want to delete ${product.title}?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Get.find<ProductRepository>().xoaSanPham(product.id);
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Delete'),
  //         ),
  //       ],
  //     ),
    );
  }
}