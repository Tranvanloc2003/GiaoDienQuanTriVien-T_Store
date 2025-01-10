import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:admin_panel/common/widgets/texts/section_heading.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/edit/change_email.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/edit/change_name.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/edit/change_phone.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/edit/change_username.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/profile_menu.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditManagerScreen extends StatelessWidget {
  const EditManagerScreen({super.key, required this.users});
 final UserModel users;
  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Chỉnh sửa người dùng",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
        actions: [
          IconButton(
            onPressed: () {
              // Hiển thị dialog xác nhận lưu thay đổi
              Get.defaultDialog(
                title: "Xác nhận",
                content: const Text("Bạn có muốn lưu các thay đổi?"),
                confirm: ElevatedButton(
                  onPressed: () {
                    // Thực hiện lưu thay đổi
                    controller.capNhatThongTinNguoiDung(users);
                    Get.back(); // Đóng dialog
                    Get.back(); // Quay lại màn hình trước
                  },
                  child: const Text("Lưu"),
                ),
                cancel: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Hủy"),
                ),
              );
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      //Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //Hình đại diện
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = users.anhDaiDien;
                      final image =
                          networkImage.isNotEmpty ? networkImage : TImages.user;
                      if (controller.imageUploading.value) {
                        return const TShimmerEffect(
                          height: 80.0,
                          width: 80.0,
                          radius: 80.0,
                        );
                      } else {
                        return CircleAvatar(
                          radius: 42.5,
                          backgroundColor: TColors.primary,
                          foregroundColor: TColors.primary,
                          child: TCircularImage(
                            image: image,
                            fit: BoxFit.cover,
                            width: 80.0,
                            height: 80.0,
                            imageType: networkImage.isNotEmpty ? ImageType.network : ImageType.asset,
                          ),
                        );
                      }
                    }),
                    TextButton(
                        onPressed: () => controller.taiLenHinhAnhHoSoNguoiDung(),
                        child: Text(
                          "Thay Đổi Ảnh Đại Diện",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: TColors.primary),
                        ))
                  ],
                ),
              ),
              //Chi tiết
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const TSectionHeading(
                title: "Thông Tin Hồ Sơ",
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              TProfileMenu(
                title: "Tên",
                value: users.fullName,
                needIcon: true,
                onPressed: () => Get.to(() =>  ChangeManagerNameScreen(user: users,)),
              ),
              TProfileMenu(
                title: "Tên Người Dùng",
                value: users.tenNguoiDung,
                needIcon: true,
                onPressed: () => Get.to(()=> ManagerUsernameScreen(user: users)),
              ),
              //
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const TSectionHeading(
                title: "Thông Tin Người Dùng",

              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TProfileMenu(
                title: "ID Người Dùng",
                icon: Iconsax.copy,
                needIcon: true,
                value: users.maNguoiDung ?? '',
                onPressed: () {},
              ),
              TProfileMenu(
                title: "Email",
                value: users.email,
                needIcon: true,
                onPressed: () => Get.to(()=> ManagerEmailScreen(user: users)),
              ),
              TProfileMenu(
                title: "Điện Thoại",
                value: users.soDienThoai,
                onPressed: () =>Get.to(()=> ManagerPhonenumberScreen(user: users,)),
              ),
              TProfileMenu(
                title: "Giới Tính",
                value: "Nam",
                onPressed: () {},
              ),
              TProfileMenu(
                title: "Ngày Sinh",
                value: "12 Tháng 8, 2003",
                onPressed: () {},
              ),

              const Divider(),

              Center(
                child: TextButton(
                  onPressed: () => controller.xoaTaiKhoanPopUp(users.maNguoiDung!),
                  child: Text(
                    "Xóa tài khoản",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: const Color.fromARGB(255, 255, 75, 75)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
