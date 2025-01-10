import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/device/device_utility.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController{
  // 
  
  final activeItem = Routes.responsiveDesignTutorialScreen.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route){
    activeItem.value = route;
  }

  void changeHoverItem(String route){
    if(!isActive(route)) hoverItem.value = route;


  } 
  bool isActive(String route){
    return activeItem.value == route;
  }
  bool isHovering(String route){
    return hoverItem.value == route;
  } 
  void menuOnTap(String route){
    if(!isActive(route)){
      changeActiveItem(route);
    if(TDeviceUtils.isMobileScreen(Get.context!)) Get.back();

    Get.toNamed(route);
    }
  }
}