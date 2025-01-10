import 'package:admin_panel/data/repository/address/address_repository.dart';
import 'package:admin_panel/features/address/models/address_model.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final hoTen = TextEditingController();
  final soDienThoai = TextEditingController();
  final diaChi = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  Rx<DiaChiModel> selectedAddress = DiaChiModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  Future<void> layDiaChiNguoiDung() async {
    try {
      isLoading.value = true;
      final addresses = await addressRepository.layDiaChiNguoiDung();
      if (addresses.isNotEmpty) {
        selectedAddress.value = addresses.first;
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> getDiaChiJson() {
    return {
      'Name': selectedAddress.value.hoTen,
      'PhoneNumber': selectedAddress.value.soDienThoai,
      'Street': selectedAddress.value.duong,
      'Country': selectedAddress.value.datNuoc,
      'City': selectedAddress.value.tinh,
    };
  }
}
