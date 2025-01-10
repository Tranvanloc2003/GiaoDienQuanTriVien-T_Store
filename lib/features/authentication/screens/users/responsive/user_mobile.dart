import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/common/widgets/containers/cart_container.dart';
import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:admin_panel/common/widgets/layouts/grid_layout.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/add_user.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/edit_user.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/search_user.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/user_detail_screen.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';


class UserMobile extends StatelessWidget {
  const UserMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
 final textEditingController = TextEditingController();
    return Scaffold(
      appBar: TAppBar(
        title: const Text('Quản lí người dùng'),
        showBackArrow: true,
       
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),
              SearchUserWidgets(textEditingController: textEditingController, controller: controller, hintText: 'Tìm kiếm người dùng...'),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              Obx(() {
                if (controller.userList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FutureBuilder(
                  future: controller.timKiemNguoiDung(controller.searchQuery.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                      return const Center(
                        child: Text('Không tìm thấy người dùng...'),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: TSizes.gridViewSpacing,
                        crossAxisSpacing: TSizes.gridViewSpacing,
                        mainAxisExtent: 250,
                      ),
                      itemCount: controller.userList.length,
                      itemBuilder: (context, index) {
                        final user = controller.userList[index];
                        return Container(
                          padding: const EdgeInsets.all(TSizes.sm),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              InkWell( 
                                onTap: () => Get.to(() => UserDetailScreen(user: user)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: user.anhDaiDien.isNotEmpty ? user.anhDaiDien : TImages.user,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.person),
                                    ),
                                    const SizedBox(height: TSizes.spaceBtwItems),

                                    Text(
                                      user.fullName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      user.email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      'Vai trò: ${user.vaiTro == true ? "Admin" : "User"}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => Get.to(() => EditManagerScreen(users: user)),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => controller.xoaTaiKhoanPopUp(user.maNguoiDung ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
