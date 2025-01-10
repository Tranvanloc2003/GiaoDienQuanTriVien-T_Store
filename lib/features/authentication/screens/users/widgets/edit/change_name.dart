import 'package:admin_panel/common/widgets/appbar/appbar.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeManagerNameScreen extends StatelessWidget {
  final UserModel user;

  const ChangeManagerNameScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    controller.initializeNames(user);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change User Name', 
          style: Theme.of(context).textTheme.headlineSmall
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.capNhatTenFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.firstName,
                validator: (value)=> TValidator.validateEmptyText('First name', value),
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.lastName,
                validator:(value)=> TValidator.validateEmptyText('Last name', value),
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.capNhatTen(user.maNguoiDung??''),
                  child: const Text('Update Name'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}