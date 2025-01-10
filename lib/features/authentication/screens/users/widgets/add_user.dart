import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    
    return Scaffold(
      appBar: TAppBar(
        title: const Text('Thêm người dùng mới'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.addUserFromkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Họ và Tên
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.firstName,
                        validator: (value) => TValidator.validateEmptyText('Họ', value),
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'Họ',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.lastName,
                        validator: (value) => TValidator.validateEmptyText('Tên', value),
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'Tên',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                /// Tên người dùng
                TextFormField(
                  controller: controller.userName,
                  validator: (value) => TValidator.validateEmptyText('Tên người dùng', value),
                  decoration: const InputDecoration(
                    labelText: 'Tên người dùng',
                    prefixIcon: Icon(Iconsax.user_edit),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                /// Email
                TextFormField(
                  controller: controller.email,
                  validator: (value) => TValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Iconsax.direct),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                /// Số điện thoại
                TextFormField(
                  controller: controller.phone,
                  validator: (value) => TValidator.validatePhoneNumber(value),
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Iconsax.call),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                /// Mật khẩu
                TextFormField(
                  controller: controller.password,
                  validator: (value) => TValidator.validatePassword(value),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Iconsax.password_check),
                    suffixIcon: Icon(Iconsax.eye_slash),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                /// Quyền người dùng
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Checkbox Admin
                    Row(
                      children: [
                        const Text('Admin'),
                        Obx(
                          () => Checkbox(
                            value: controller.isAdmin.value,
                            onChanged: (value) => controller.chuyenDoiLoaiNguoiDung(value, 'admin'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    // Checkbox User
                    Row(
                      children: [
                        const Text('User'),
                        Obx(
                          () => Checkbox(
                            value: controller.isUser.value,
                            onChanged: (value) => controller.chuyenDoiLoaiNguoiDung(value, 'user'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// Nút Thêm người dùng
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.themNguoiDung(),
                    child: const Text('Thêm người dùng'),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}