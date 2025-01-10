import 'package:admin_panel/data/repository/authentication/authentication_repository.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';

class RoutesMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print('-----> RoutesMiddleware: redirect: $route');
   return AuthenticationRepository.instance.isAuthenticated ? null : RouteSettings(name: Routes.login);
   
  }
}