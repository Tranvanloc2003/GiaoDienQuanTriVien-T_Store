import 'package:admin_panel/data/repository/authentication/authentication_repository.dart';
import 'package:admin_panel/data/repository/user/user_repository.dart';
import 'package:admin_panel/features/authentication/model/user_model.dart';
import 'package:admin_panel/features/authentication/screens/users/responsive/user_mobile.dart';
import 'package:admin_panel/features/authentication/screens/users/widgets/edit_user.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/helpers/network_manager.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  
  // Thay đổi cách khởi tạo userRepository
  final userRepository = UserRepository(); // Bỏ Get.put()
  
  // Bỏ dòng này vì nó tạo ra vòng lặp
  // final userController = UserController.instance;
  
  // ...existing code...
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxString searchQuery = ''.obs;
  RxList<UserModel> searchResults = <UserModel>[].obs;
  final imageUploading = false.obs;

  //biến các trường
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final admin = TextEditingController();
  GlobalKey<FormState> capNhatEmailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> capNhatTenFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> capNhatUserNameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePhoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> addUserFromkey = GlobalKey<FormState>();

  final isAdmin = false.obs;
  final isUser = true.obs;

  void initializeNames(UserModel user) {
    firstName.text = user.ho;
    lastName.text = user.ten;
    email.text = user.email;
    userName.text =user.tenNguoiDung;
    phone.text =user.soDienThoai;
  }
  @override
  void onInit() {
    taiChiTietNguoiDung();
    taiNguoiDung(); // Add this to load users when controller initializes
    super.onInit();
  }

  void clear() {
    searchQuery.value = '';
    searchResults.clear();
  }

  // Fetch user details
  Future<UserModel> taiChiTietNguoiDung() async {
    try {
      loading.value = true;
      final user = await userRepository.taiChiTietAdmin();
      this.user.value = user;
      return user;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Something went wrong', message: e.toString());
      return UserModel.empty();
    } finally {
      loading.value = false;
    }
  }

  // Sửa lại phương thức taiNguoiDung
  Future<void> taiNguoiDung() async {
    try {
      loading.value = true;
      final users = await userRepository.layTatCaNguoiDung();

      // Kiểm tra null trước khi gán
      if (users != null) {
        userList.assignAll(users);
        print('UserController: Đã tải ${users.length} người dùng');
      } else {
        print('UserController: Không có dữ liệu người dùng');
        userList.clear();
      }
    } catch (e) {
      print('UserController: Lỗi khi tải danh sách người dùng: $e');
      userList.clear();
    } finally {
      loading.value = false;
    }
  }

  // Thêm method để refresh data
  Future<void> lamMoiDanhSachNguoiDung() async {
    await taiNguoiDung();
  }

  // Get filtered users
  List<UserModel> layNguoiDungDaLoc(String searchTerm) {
    if (searchTerm.isEmpty) return userList;

    return userList.where((user) {
      final nameLower = user.fullName.toLowerCase();
      final emailLower = user.email.toLowerCase();
      final searchLower = searchTerm.toLowerCase();

      return nameLower.contains(searchLower) ||
          emailLower.contains(searchLower);
    }).toList();
  }


  Future<List<UserModel>> timKiemNguoiDung(String query) async {
    try {
      // Return all products if query is empty
      if (query.isEmpty) return userList;

      // Filter featuredProducts based on search query
      return userList.where((user) {
        final fullnameMatch =
            user.fullName.toLowerCase().contains(query.toLowerCase());
        final emailMatch =
            user.email.toLowerCase().contains(query.toLowerCase());
        return fullnameMatch || emailMatch;
      }).toList();
    } catch (e) {
      TLoaders.errorSnackBar(title: "Search Error", message: e.toString());
      return [];
    }
  }

//Upload Profile IMage
  Future<void> taiLenHinhAnhHoSoNguoiDung() async {
    try {
      imageUploading.value = true;
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512
      );
      
      if (image != null) {
        // Upload Image
        final imageUrl = await userRepository.taiHinhAnh("Users/Images/Profile/", image);

        // Update User Image Record in Firebase
        Map<String, dynamic> json = {"ProfilePicture": imageUrl};
        await userRepository.capNhatTruongDon(json);

        // Update local user model
        user.value.anhDaiDien = imageUrl;
        user.refresh();

        // Update in userList
        final index = userList.indexWhere((u) => u.maNguoiDung == user.value.maNguoiDung);
        if (index != -1) {
          userList[index].anhDaiDien = imageUrl;
          userList.refresh();
        }

        // Reload user data from Firebase to ensure everything is in sync
        await taiNguoiDung();

        TLoaders.successSnackBar(
          title: "Thành công",
          message: "Ảnh đại diện đã được cập nhật"
        );

        // Refresh current screen
        if (Get.currentRoute.contains('EditManagerScreen')) {
          Get.back();
          Get.to(() => EditManagerScreen(users: user.value));
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Lỗi!",
        message: "Không thể cập nhật ảnh đại diện: $e"
      );
    } finally {
      imageUploading.value = false;
    }
  }

  // Delete user with specific ID
  Future<void> xoaNguoiDung(String userId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Deleting user...', TImages.docerAnimation);

      // Delete from Firebase
      await userRepository.xoaNguoiDung(userId);

      // Remove from local list
      userList.removeWhere((user) => user.maNguoiDung == userId);

      // Close loading dialog
      TFullScreenLoader.stopLoading();

      // Show success message
      TLoaders.successSnackBar(
          title: 'Success', message: 'User deleted successfully');

      // Refresh the list
      await taiNguoiDung();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Unable to delete user: $e');
    }
  }

  // Modified delete warning popup
  void xoaTaiKhoanPopUp(String userId) {
    Get.defaultDialog(
        title: "Delete User",
        titlePadding: const EdgeInsets.only(top: TSizes.defaultSpace),
        contentPadding: const EdgeInsets.all(TSizes.md),
        middleText:
            "Are you sure you want to delete this user? This action cannot be undone.",
        confirm: ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await xoaNguoiDung(userId);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red)),
            child: const Text('Delete', style: TextStyle(color: Colors.white))),
        cancel: OutlinedButton(
            onPressed: () => Get.back(), child: const Text('Cancel')));
  }

  //thêm và sửa user
  Future<void> capNhatTen(String userId) async {
    try {
      // Hiển thị loading
      TFullScreenLoader.openLoadingDialog(
          "Đang cập nhật thông tin...", TImages.docerAnimation);

      // Kiểm tra kết nối mạng
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Không có kết nối mạng',
            message: "Vui lòng kiểm tra kết nối mạng và thử lại.");
        return;
      }

      // Validate form
      if (!capNhatTenFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Cập nhật tên trong Firebase
      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim()
      };

      // Tìm user trong danh sách và cập nhật
      final userToUpdate = userList.firstWhere((user) => user.maNguoiDung == userId);
      userToUpdate.ho = firstName.text.trim();
      userToUpdate.ten = lastName.text.trim();

      // Cập nhật trong Firebase
      await userRepository.capNhatTruongDon(name);

      // Refresh danh sách users
      await taiNguoiDung();

      TFullScreenLoader.stopLoading();

      // Hiển thị thông báo thành công
      TLoaders.successSnackBar(
          title: "Thành công", 
          message: "Đã cập nhật tên người dùng");

       // Quay lại màn hình trước với user đã được cập nhật
      Get.off(() => EditManagerScreen(users: userToUpdate));

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: "Lỗi",
          message: "Đã xảy ra lỗi khi cập nhật thông tin. Vui lòng thử lại.");
    }
  }
  Future<void> capNhatEmail(String userId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Đang cập nhật thông tin...", TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Không có kết nối mạng',
            message: "Vui lòng kiểm tra kết nối mạng và thử lại.");
        return;
      }

      if (!capNhatEmailFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> emails = {
        'Email': email.text.trim(),
      };

      // Cập nhật trong Firebase với userId
      await userRepository.capNhatTruongDon(emails);

      // Lấy thông tin user mới nhất từ Firebase
      final updatedUserDoc = await userRepository.layNguoiDungTheoId(userId);
   
        // Refresh danh sách users
        await taiNguoiDung();

        TFullScreenLoader.stopLoading();
        TLoaders.successSnackBar(
            title: "Thành công", 
            message: "Đã cập nhật email người dùng");

        Get.off(() => EditManagerScreen(users: updatedUserDoc));
      }

     catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: "Lỗi",
          message: "Đã xảy ra lỗi khi cập nhật thông tin. Vui lòng thử lại.");
    }
  }
  Future<void> capNhatUserName(String userId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Đang cập nhật thông tin...", TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Không có kết nối mạng',
            message: "Vui lòng kiểm tra kết nối mạng và thử lại.");
        return;
      }

      if (!capNhatUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> username = {
        'UserName': userName.text.trim(),
      };

      // Cập nhật trong Firebase với userId
      await userRepository.capNhatTruongDon(username);

      // Lấy thông tin user mới nhất từ Firebase
      final updatedUserDoc = await userRepository.layNguoiDungTheoId(userId);
   
        // Refresh danh sách users
        await taiNguoiDung();

        TFullScreenLoader.stopLoading();
        TLoaders.successSnackBar(
            title: "Thành công", 
            message: "Đã cập nhật email người dùng");

        Get.off(() => EditManagerScreen(users: updatedUserDoc));
      }

     catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: "Lỗi",
          message: "Đã xảy ra lỗi khi cập nhật thông tin. Vui lòng thử lại.");
    }
  }
  Future<void> capNhatSoDienThoai(String userId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Đang cập nhật thông tin...", TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Không có kết nối mạng',
            message: "Vui lòng kiểm tra kết nối mạng và thử lại.");
        return;
      }

      if (!updatePhoneFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> phoneNumber = {
        'PhoneNumber': phone.text.trim(),
      };

      // Cập nhật trong Firebase với userId
      await userRepository.capNhatTruongDon(phoneNumber);

      // Lấy thông tin user mới nhất từ Firebase
      final updatedUserDoc = await userRepository.layNguoiDungTheoId(userId);
   
        // Refresh danh sách users
        await taiNguoiDung();

        TFullScreenLoader.stopLoading();
        TLoaders.successSnackBar(
            title: "Thành công", 
            message: "Đã cập nhật số điện thoại người dùng");

        Get.off(() => EditManagerScreen(users: updatedUserDoc));
      }

     catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: "Lỗi",
          message: "Đã xảy ra lỗi khi cập nhật thông tin. Vui lòng thử lại.");
    }
  }
  Future<void> themNguoiDung() async {
    try {
      if (!addUserFromkey.currentState!.validate()) {
        return;
      }

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(
          title: 'Không có kết nối mạng',
          message: 'Vui lòng kiểm tra kết nối mạng và thử lại'
        );
        return;
      }

      TFullScreenLoader.openLoadingDialog(
        "Đang xử lý...", 
        TImages.docerAnimation
      );

      // Tạo user với custom claims để bypass verify email
      final userCredential = await AuthenticationRepository.instance.taoTaiKhoanAdmin(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final newUser = UserModel(
        maNguoiDung: userCredential.user!.uid,
        ho: firstName.text.trim(),
        ten: lastName.text.trim(),
        tenNguoiDung: userName.text.trim(),
        email: email.text.trim(),
        soDienThoai: phone.text.trim(),
        vaiTro: isAdmin.value ? AppRole.admin : AppRole.user,
        anhDaiDien: "",
      );

      await userRepository.luuHoSoNguoiDung(newUser);
      await taiNguoiDung();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: "Thành công",
        message: "Đã thêm người dùng mới"
      );

      xoaForm();
      Get.off(() => UserMobile());

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: "Lỗi", 
        message: e.toString()
      );
    }
  }

  void chuyenDoiLoaiNguoiDung(bool? value, String type) {
    if (type == 'admin') {
      isAdmin.value = value ?? false;
      isUser.value = !isAdmin.value; // Nếu chọn admin thì bỏ chọn user
    } else {
      isUser.value = value ?? true;
      isAdmin.value = !isUser.value; // Nếu chọn user thì bỏ chọn admin
    }
  }

  // Add method to clear form
  void xoaForm() {
    firstName.clear();
    lastName.clear();
    userName.clear();
    email.clear();
    phone.clear();
    password.clear();
    isAdmin.value = false;
    isUser.value = true; 
  }

  Future<void> capNhatThongTinNguoiDung(UserModel user) async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Đang cập nhật thông tin...', 
        TImages.docerAnimation
      );

      // Kiểm tra kết nối mạng
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Cập nhật thông tin trong Firebase
      await userRepository.capNhatNguoiDung(user);

      // Cập nhật lại danh sách người dùng
      await taiNguoiDung();

      TFullScreenLoader.stopLoading();
      
      // Hiển thị thông báo thành công
      TLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Thông tin người dùng đã được cập nhật'
      );

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể cập nhật thông tin người dùng'
      );
    }
  }
}
