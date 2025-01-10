import 'package:admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:admin_panel/common/widgets/layouts/menu/menu_item.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
            color: TColors.white,
            border: Border(right: BorderSide(color: TColors.grey, width: 1))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //image
              TCircularImage(
                width: 100,
                height: 100,
                image: TImages.darkAppLogo,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Menu',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
//menu items
                    TMenuItems(itemName: 'Sản Phẩm', icon: Iconsax.status, route: Routes.products,),
                    
                      
                    TMenuItems(itemName: 'Thương Hiệu', icon: Iconsax.image, route: Routes.brands,),
                    
                    TMenuItems(itemName: 'Banner', icon: Iconsax.picture_frame, route: Routes.banners,),

                    TMenuItems(itemName: 'Người Dùng', icon: Iconsax.user, route: Routes.user),
                    TMenuItems(itemName: 'Thống kê doanh thu', icon: Iconsax.activity, route: Routes.revenueDashboard),
                    TMenuItems(itemName: 'Đơn hàng', icon: Iconsax.shopping_bag, route: Routes.orderList),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

