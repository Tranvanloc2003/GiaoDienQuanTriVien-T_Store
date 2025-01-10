import 'package:admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:admin_panel/utils/constants/enums.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});
final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(.5),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                icon: Icon(Iconsax.menu),
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
              )
            : null,
            
        title:!TDeviceUtils.isMobileScreen(context) ? SizedBox(
          width: 400,
          child: TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.search_normal),
                hintText: 'Search here...'),
          ),
        ): null,
        actions: [
          if (!TDeviceUtils.isDesktopScreen(context))
            IconButton(
              icon: Icon(Iconsax.search_normal),
              onPressed: () {},
            ),
          IconButton(
            icon: Icon(Iconsax.notification),
            onPressed: () {},
          ),
          SizedBox(
            width: TSizes.spaceBtwItems / 2,
          ),
          Row(
            children: [
              Obx(
                ()=> TRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  imageType: userController.user.value.anhDaiDien.isNotEmpty ?ImageType.network: ImageType.asset,
                  image:userController.user.value.anhDaiDien.isNotEmpty?userController.user.value.anhDaiDien:  TImages.user,
                ),
              ),
              SizedBox(
                width: TSizes.sm,
              ),
              //name and email
              if (!TDeviceUtils.isMobileScreen(context))
                Obx(
                  ()=> Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      userController.loading.value
                          ? TShimmerEffect(width: 50, height: 13)
                          :
                      Text(
                        userController.user.value.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                       userController.loading.value
                          ? TShimmerEffect(width: 50, height: 13)
                          :
                      Text(
                        
                        userController.user.value.email,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
