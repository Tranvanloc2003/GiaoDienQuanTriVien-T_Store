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

  //Load Category Data
  Future<void> taiDanhMuc() async {
    try {
      //Loading
      isLoading.value = true;

      //fetch categories from data source
      final categories = await _categoryRepositroy.layTatCaDanhMuc();

      //update category list
      allCategories.assignAll(categories);

      //Filter featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.noiBat && category.maCapCha.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      //Show error message
      TLoaders.errorSnackBar(title: "Ôi Không!", message: e.toString());
    } finally {
      //Remove Loader
      isLoading.value = false;
    }
  }

  Future<void> taoDanhMuc(QuanliDanhMucModel category) async {
    try {
      await _categoryRepositroy.taoDanhMuc(category);
      await taiDanhMuc(); // Refresh the list
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> capNhatDanhMuc(String categoryId, Map<String, dynamic> data) async {
    try {
      await _categoryRepositroy.capNhatDanhMuc(categoryId, data);
      await taiDanhMuc(); // Refresh the list
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> xoaDanhMuc(String categoryId) async {
    try {
      await _categoryRepositroy.xoaDanhMuc(categoryId);
      await taiDanhMuc(); // Refresh the list
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
