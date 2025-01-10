import 'package:get/get.dart';

class Routes {
  static const responsiveDesignTutorialScreen = '/responsive-design-tutorial/';
  static const sidebarMenuItems = [
    dashboard,
  ];
  // Auth routes
  static const login = '/login';
  static const forgetPassword = '/forget-password/';
  static const resetPassword = '/reset-password/';
  static const dashboard = '/dashboard';
  static const media = '/media';

  // Banner management
  static const banners = '/banners';
  static const taoBanner = '/taoBanner';
  static const editBanner = '/editBanner';

  // Product management
  static const products = '/products';
  static const taoSanPham = '/taoSanPhams'; // Đảm bảo route này đã tồn tại
  static const editProduct = '/editProduct';

  // Category management
  static const categories = '/categories';
  static const taoDanhMuc = '/taoDanhMuc';
  static const editCategory = '/editCategory';

  // Brand management
  static const brands = '/brands';
  static const taoThuongHieu = '/taoThuongHieu';
  static const editBrand = '/editBrand';

  // Customer management
  static const user = '/user';
  static const taoNguoiDungs = '/taoNguoiDungs';
  static const userDetails = '/userDetails';

  //tét
  static const homePage = '/home-page';
  static const revenueDashboard = '/revenue-dashboard';
  static const orderList = '/order-list';
}