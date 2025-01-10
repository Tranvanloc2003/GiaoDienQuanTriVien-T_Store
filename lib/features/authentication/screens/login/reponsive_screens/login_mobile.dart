import 'package:admin_panel/features/authentication/screens/login/widgets/form_login.dart';
import 'package:admin_panel/features/authentication/screens/login/widgets/login_header.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginMobileScreen extends StatelessWidget {
  const LoginMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(children: [
         HeaderLogin(),
                      //form
FormLogin(),
      ],),
      ),
    ),);
  }
}