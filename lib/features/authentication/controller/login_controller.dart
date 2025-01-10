import 'package:admin_panel/data/repository/authentication/authentication_repository.dart';
import 'package:admin_panel/data/repository/user/user_repository.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:admin_panel/utils/helpers/network_manager.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();
 
  final anMatKhau = true.obs;
  final ghiNhoDangNhap = false.obs;
  final luuTruCucBo = GetStorage();

  final email = TextEditingController();
  final matKhau = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = luuTruCucBo.read("REMEMBER_ME_EMAIL") ?? '';
    matKhau.text = luuTruCucBo.read("REMEMBER_ME_PASSWORD") ?? '';
    super.onInit();
  }

  //handels email and password sign-in process
 Future<void> dangNhapEmailMatKhau() async {
  try {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    TFullScreenLoader.openLoadingDialog("Đang đăng nhập...", TImages.docerAnimation);

    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(
        title: 'Không có kết nối',
        message: "Vui lòng kiểm tra kết nối mạng"
      );
      return;
    }

    // Đăng nhập
    await AuthenticationRepository.instance.dangNhap(
      email.text.trim(), 
      matKhau.text.trim()
    );

    // Lưu remember me
    if (ghiNhoDangNhap.value) {
      luuTruCucBo.write("REMEMBER_ME_EMAIL", email.text.trim());
      luuTruCucBo.write("REMEMBER_ME_PASSWORD", matKhau.text.trim());
    }

    TFullScreenLoader.stopLoading();
    
    // Chuyển màn hình sau khi đăng nhập thành công
    Get.offAllNamed(Routes.dashboard);

  } catch (e) {
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: "Lỗi đăng nhập", message: e.toString());
  }
}
  //handles registration of admin user
  Future<void> dangKiAdmin() async{
    try {
      TFullScreenLoader.openLoadingDialog('Register Admin Account...', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.dangKi(TTexts.adminEmail, TTexts.adminPassword);

      final userRepository = Get.put(UserRepository());  
      await userRepository.taoNguoiDung(UserModel(
        maNguoiDung: AuthenticationRepository.instance.authUser!.uid,
        ho: 'Loc',
        ten: 'Admin', 
        email: TTexts.adminEmail,
        vaiTro: AppRole.admin,
        thoiGianTao: DateTime.now(),
      ));

      TFullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }
}