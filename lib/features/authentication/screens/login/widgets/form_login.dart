import 'package:admin_panel/features/authentication/controller/login_controller.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return Form(
      key: loginController.loginFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            //email
            TextFormField(
              controller: loginController.email,
              validator: TValidator.validateEmail,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),
            //password
            Obx(
              ()=> TextFormField(
                controller: loginController.matKhau,
                obscureText: loginController.anMatKhau.value,
                validator:TValidator.validatePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: TTexts.password,
                  suffixIcon: IconButton(onPressed: () => loginController.anMatKhau.value = !loginController.anMatKhau.value,icon: Icon(loginController.anMatKhau.value ? Iconsax.eye_slash: Iconsax.eye,)),
                ),
              ),
            ),
            SizedBox(
              height: TSizes.spaceBtwInputFields / 2,
            ),
            //remember me
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //remember me
                Obx(
                  ()=> Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: loginController.ghiNhoDangNhap.value,
                        onChanged: (value) => loginController.ghiNhoDangNhap.value = value!,
                      ),
                      Text(TTexts.rememberMe),
                      
                    ],
                  ),
                ),
                //forgot password
                TextButton(onPressed: ()=> Get.toNamed(Routes.forgetPassword), child: Text(TTexts.forgetPassword),)
              ],
            ),
            SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            //button login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => loginController.dangNhapEmailMatKhau(),
                // onPressed: () => loginController.dangKiAdmin(),

                child: Text(TTexts.signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
