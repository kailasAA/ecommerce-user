import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.pushNamed(context, RouteGenerator.authScreen);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      body: Center(
          child: SizedBox(
              height: 300.h,
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: Lottie.asset(Assets.splash),
                    ),
                    Text(
                      "Fashion Store",
                      style: FontPallette.headingStyle,
                    ),
                  ],
                ),
              ))),
    );
  }
}
