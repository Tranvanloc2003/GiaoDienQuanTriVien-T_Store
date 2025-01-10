import 'package:admin_panel/data/repository/banners/banners_repositoty.dart';
import 'package:admin_panel/features/shop/models/banner_model.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';


class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  //Variables
  final carauselCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<QuanliBannerModel> banners = <QuanliBannerModel>[].obs;

  @override
  void onInit() {
    taiBanner();
    super.onInit();
  }

  void updatePageIndicator(index) {
    carauselCurrentIndex.value = index;
  }

  //Fetch banners
  Future<void> taiBanner() async {
    try {
      //Loading
      isLoading.value = true;

      //Ftech banners
      final bannerRepository = Get.put(BannerRepository());
      final banners = await bannerRepository.taiBanner();

      //Assign banners
      this.banners.assignAll(banners);
    } catch (e) {
      //Show error message
      TLoaders.errorSnackBar(title: "Ôi Không!", message: e.toString());
    } finally {
      //Remove Loader
      isLoading.value = false;
    }
  }
}
