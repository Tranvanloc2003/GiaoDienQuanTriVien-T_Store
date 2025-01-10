import 'package:admin_panel/features/dashboard/controllers/dashboard_controller.dart';
import 'package:admin_panel/features/dashboard/widgets/product_data_source.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardDesktopScreen extends StatelessWidget {
  final controller = Get.put(DashboardController());

  DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Add your desktop dashboard content here
        child: const Center(
          child: Text('Desktop Dashboard Content'),
        ),
      ),
    );
  }
}
