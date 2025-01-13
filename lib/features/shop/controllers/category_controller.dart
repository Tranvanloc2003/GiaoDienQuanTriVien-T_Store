import 'package:admin_panel/data/repository/category/category_repository.dart';
import 'package:admin_panel/data/repository/product/product_repository.dart';
import 'package:admin_panel/features/shop/models/category_model.dart';
import 'package:admin_panel/features/shop/models/product_model.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';


class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  //Variables
  final _categoryRepositroy = Get.put(CategoryRepository());
  RxList<QuanliDanhMucModel> allCategories = <QuanliDanhMucModel>[].obs;
  RxList<QuanliDanhMucModel> featuredCategories = <QuanliDanhMucModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    taiDanhMuc();
  }


  Future<void> taiDanhMuc() async {
    try {

      isLoading.value = true;

   
      final categories = await _categoryRepositroy.layTatCaDanhMuc();

  
      allCategories.assignAll(categories);

    
      featuredCategories.assignAll(allCategories
          .where((category) => category.noiBat && category.maCapCha.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
  
      TLoaders.errorSnackBar(title: "Ôi Không!", message: e.toString());
    } finally {
      //Remove Loader
      isLoading.value = false;
    }
  }



  

  
}
