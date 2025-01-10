import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ManagerEmailScreen extends StatelessWidget {
  const ManagerEmailScreen({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    controller.initializeNames(user);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Email', 
          style: Theme.of(context).textTheme.headlineSmall
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.capNhatEmailFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.email,
                validator: (value)=> TValidator.validateEmptyText('Email', value),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.capNhatEmail(user.maNguoiDung??''),
                  child: const Text('Update Email'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}