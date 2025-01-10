import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ImageController extends GetxController {
  static ImageController get instance => Get.find();

  //Variables
  RxString selectedProductImage = "".obs;

  //Get allimages form prodcut variations
  List<String> getAllProductImages(QuanliSanPhamModel product) {
    //toadd unique image sonly
    Set<String> images = {};

    selectedProductImage.value = product.anhDaiDien;
    if (product.loaiSanPham == ProductType.single.toString()) {
      if (product.danhSachAnh != null) {
        images.addAll(product.danhSachAnh!);
      }
    } else {
      if (product.bienTheSanPham != null ||
          product.bienTheSanPham!.isNotEmpty) {
        images.addAll(
            product.bienTheSanPham!.map((variation) => variation.hinhAnh));
      }
    }
    return images.toList();
  }

  //ShowImage Popup
  void showEnlargeImage(String image) {
    Get.to(
        fullscreenDialog: true,
        () => Dialog.fullscreen(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.defaultSpace * 2,
                        horizontal: TSizes.defaultSpace),
                    child: CachedNetworkImage(imageUrl: image),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 150.0,
                      child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            "Close",
                            style: Theme.of(Get.context!).textTheme.titleMedium,
                          )),
                    ),
                  )
                ],
              ),
            ));
  }
}
