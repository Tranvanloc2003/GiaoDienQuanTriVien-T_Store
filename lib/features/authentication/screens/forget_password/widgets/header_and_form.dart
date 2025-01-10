import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HeaderAndForm extends StatelessWidget {
  const HeaderAndForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //header
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_left_2),
        ),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        Text(
          TTexts.forgetPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        Text(
          TTexts.forgetPasswordSubTitle,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(
          height: TSizes.spaceBtwSections * 2,
        ),
    
        //form
        Form(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: TTexts.email,
              suffixIcon: Icon(Iconsax.direct_right),
            ),
          ),
        ),
        SizedBox(
          height: TSizes.spaceBtwSections,
        ),
        SizedBox(width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(Routes.resetPassword, parameters: {'email': 'email@email.com'}),
          child: Text(TTexts.submit),
        ),
        ),
        SizedBox(
          height: TSizes.spaceBtwSections * 2,
        ),
      ],
    );
  }
}
