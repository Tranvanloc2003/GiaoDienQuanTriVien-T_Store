import 'package:admin_panel/app.dart';
import 'package:admin_panel/common/widgets/response/response_layout_screen.dart';
import 'package:admin_panel/features/authentication/screens/forget_password/forget_password.dart';
import 'package:admin_panel/features/authentication/screens/login/login.dart';
import 'package:admin_panel/features/authentication/screens/reset_password/reset_password.dart';
import 'package:admin_panel/features/authentication/screens/users/user.dart';
import 'package:admin_panel/features/dashboard/dashboard.dart';
import 'package:admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:admin_panel/features/shop/screens/banners/banner.dart';
import 'package:admin_panel/features/shop/screens/brands/brands.dart';
import 'package:admin_panel/features/shop/screens/order/admin_order_list.dart';

import 'package:admin_panel/features/shop/screens/products/products.dart';
import 'package:admin_panel/features/shop/screens/products/widgets/add_product.dart';
import 'package:admin_panel/features/shop/screens/revenue/revenue_dashboard.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/routes/routes_middleware.dart';
import 'package:get/get.dart';
import 'package:admin_panel/features/shop/controllers/brand_controller.dart';
import 'package:admin_panel/features/shop/controllers/category_controller.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
        name: Routes.login,
        page: () => LoginScreen(),
        // middlewares: [RoutesMiddleware()]
        ),
    GetPage(
        name: Routes.forgetPassword,
        page: () => ForgetPasswordScreen(),
        // middlewares: [RoutesMiddleware()]
        ),
    GetPage(
        name: Routes.resetPassword,
        page: () => ResetPasswordScreen(),
        // middlewares: [RoutesMiddleware()]
        
        ),
    GetPage(
        name: Routes.dashboard,
        page: () => DashboardScreen(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.products,
        page: () => Products(),
        middlewares: [RoutesMiddleware()]),
    GetPage(
        name: Routes.taoSanPham,
        page: () => const AddProductScreen(),
    ),  
    GetPage(
        name: Routes.brands,
        page: () => const Brands(),
    ),   
    GetPage(
        name: Routes.user,
        page: () => const User(),
    ), 
     GetPage(
        name: Routes.banners,
        page: () => const Banner(),
    ), 
   
   GetPage(
        name: Routes.revenueDashboard,
        page: () => const RevenueDashboard(),
    ), 
    
    GetPage(
        name: Routes.orderList,
        page: () => const AdminOrderList(),
    ), 
  ];
}
