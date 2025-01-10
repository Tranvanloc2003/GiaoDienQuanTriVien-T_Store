import 'package:admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:admin_panel/features/authentication/screens/reset_password/widgets/reset_password_widget.dart';
import 'package:admin_panel/routes/routes.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResetPasswordDesktopTablet extends StatelessWidget {
  const ResetPasswordDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    
    return TLoginTemplate(child: 
    ResetPasswordWidget(),
    );
  }
}

