import 'dart:io';

import 'package:admin_panel/data/repository/banners/banners_repositoty.dart';
import 'package:admin_panel/features/shop/models/banner_model.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BannerMobile extends StatelessWidget {
  const BannerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerRepository());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lí ảnh quảng cáo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBannerDialog(context, controller),
          ),
        ],
      ),
      body: FutureBuilder<List<QuanliBannerModel>>(
        future: controller.taiTatCaBanner(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final banners = snapshot.data!;

          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              // Get clean ID from target screen
              final displayId = banner.manHinhDich.replaceFirst('/', '').split('/')[0];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    banner.duongDanAnh,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                  title: Text('Mã: $displayId'),  // Display clean ID here
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Màn hình đích: ${banner.manHinhDich}'),
                      Text('Hoạt động: ${banner.hoatDong}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditBannerDialog(
                            context, controller, banner),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(
                            context, controller, banner.maBanner),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Add Banner Dialog
  void _showAddBannerDialog(BuildContext context, BannerRepository controller) {
    final formKey = GlobalKey<FormState>();
    final targetScreenController = TextEditingController();
    final selectedImage = Rx<XFile?>(null);
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Banner'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Picker
                const Text('Banner Image *'),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        selectedImage.value = image;
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Obx(() => selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(selectedImage.value!.path),
                              width: 200,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                              SizedBox(height: 4),
                              Text('Select Image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Target Screen Field
                TextFormField(
                  controller: targetScreenController,
                  decoration: const InputDecoration(
                    labelText: 'Target Screen *',
                    border: OutlineInputBorder(),
                    hintText: '/home, /cart, etc.',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Target screen is required' : null,
                ),
                const SizedBox(height: 16),

                // Active Status
                StatefulBuilder(
                  builder: (context, setState) => SwitchListTile(
                    title: const Text('Active Status'),
                    value: isActive,
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                if (selectedImage.value == null) {
                  TLoaders.errorSnackBar(
                    title: 'Image Required',
                    message: 'Please select an image for the banner'
                  );
                  return;
                }

                final newBanner = QuanliBannerModel(
                  maBanner: '',
                  duongDanAnh: '',
                  manHinhDich: targetScreenController.text,
                  hoatDong: isActive,
                  tepAnh: selectedImage.value,
                );
                controller.taoBanner(newBanner);
                Navigator.pop(context);
                Get.forceAppUpdate();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Edit Banner Dialog
  void _showEditBannerDialog(
      BuildContext context, BannerRepository controller, QuanliBannerModel banner) {
    final formKey = GlobalKey<FormState>();
    final targetScreenController = TextEditingController(text: banner.manHinhDich);
    final selectedImage = Rx<XFile?>(null);
    bool isActive = banner.hoatDong;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Banner'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Preview/Picker
                const Text('Banner Image'),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        selectedImage.value = image;
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Obx(() => selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(selectedImage.value!.path),
                              width: 200,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              banner.duongDanAnh,
                              width: 200,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, size: 40),
                            ),
                          ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Target Screen Field
                TextFormField(
                  controller: targetScreenController,
                  decoration: const InputDecoration(
                    labelText: 'Target Screen *',
                    border: OutlineInputBorder(),
                    hintText: '/home, /cart, etc.',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Target screen is required' : null,
                ),
                const SizedBox(height: 16),

                // Active Status
                StatefulBuilder(
                  builder: (context, setState) => SwitchListTile(
                    title: const Text('Active Status'),
                    value: isActive,
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final updatedBanner = QuanliBannerModel(
                  maBanner: banner.maBanner,
                  duongDanAnh: banner.duongDanAnh,
                  manHinhDich: targetScreenController.text,
                  hoatDong: isActive,
                  tepAnh: selectedImage.value,
                );
                controller.capNhatBanner(banner.maBanner, updatedBanner);
                Navigator.pop(context);
                Get.forceAppUpdate();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmation(
      BuildContext context, BannerRepository controller, String bannerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Banner'),
        content: const Text('Are you sure you want to delete this banner?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.xoaBanner(bannerId);
              Navigator.pop(context);
              Get.forceAppUpdate();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}