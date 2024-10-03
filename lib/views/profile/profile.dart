import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/auth/login/view_model/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPallette.scaffoldBgColor,
        body: Column(
          children: [
            Center(
              child: Text(
                "Profile Screen",
                style: FontPallette.bodyStyle.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await context.read<LoginProvider>().logOut();

                  Navigator.pushReplacementNamed(
                      context, RouteGenerator.loginScreen);
                },
                child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
