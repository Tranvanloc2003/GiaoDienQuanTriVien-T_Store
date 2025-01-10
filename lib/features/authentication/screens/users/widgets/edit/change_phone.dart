import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ManagerPhonenumberScreen extends StatelessWidget {
  const ManagerPhonenumberScreen({super.key,required this.user});
final UserModel user;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    controller.initializeNames(user);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Username', 
          style: Theme.of(context).textTheme.headlineSmall
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.updatePhoneFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.phone,
                validator: (value)=> TValidator.validateEmptyText('Phone', value),
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.capNhatSoDienThoai(user.maNguoiDung??''),
                  child: const Text('Update Phone'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}