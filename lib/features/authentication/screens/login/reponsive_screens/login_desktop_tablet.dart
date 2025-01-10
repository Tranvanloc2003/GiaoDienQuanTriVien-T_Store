import 'package:admin_panel/common/styles/spacing_styles.dart';
import 'package:admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:admin_panel/features/authentication/screens/login/widgets/form_login.dart';
import 'package:admin_panel/features/authentication/screens/login/widgets/login_header.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/image_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class LoginDesktopTabletScreen extends StatelessWidget {
  const LoginDesktopTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(child: Column(children: [
        HeaderLogin(),
                      //form
FormLogin(),
    ],),);
  }
}

