import 'package:admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_panel/features/shop/screens/products/responsive/product_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(
      mobile: ProductMobileScreen(),
    );
  }
}