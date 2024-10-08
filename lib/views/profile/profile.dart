import 'package:ecommerce_user_side/common/common_functions.dart/dialog_box.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:ecommerce_user_side/views/auth/login/view_model/login_provider.dart';
import 'package:ecommerce_user_side/views/main_screen/viemodel/main_screen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<LoginProvider>().reset();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final loginProvider = context.read<LoginProvider>();
    final mainScreenProvider = context.read<MainScreenProvider>();

    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: FontPallette.headingStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorPallette.scaffoldBgColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15.r),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Text(user?.email ?? "",
                    style: FontPallette.headingStyle
                        .copyWith(color: ColorPallette.blackColor)),
              ),
              20.verticalSpace,
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteGenerator.orderScreen);
                },
                child: SimpleButton(
                  borderRadius: 25,
                  height: 70.h,
                  buttonColor: ColorPallette.blackColor,
                  childWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: ColorPallette.whiteColor,
                      ),
                      10.horizontalSpace,
                      Text("Orders",
                          style: FontPallette.headingStyle
                              .copyWith(color: ColorPallette.whiteColor)),
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              // InkWell(
              //   onTap: () {},
              //   child: SimpleButton(
              //     borderRadius: 25,
              //     height: 70.h,
              //     buttonColor: ColorPallette.blackColor,
              //     childWidget: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.favorite_outlined,
              //           color: ColorPallette.whiteColor,
              //         ),
              //         10.horizontalSpace,
              //         Text("Wishlist",
              //             style: FontPallette.headingStyle
              //                 .copyWith(color: ColorPallette.whiteColor)),
              //       ],
              //     ),
              //   ),
              // ),
              // 10.verticalSpace,
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteGenerator.addressScreen);
                },
                child: SimpleButton(
                  borderRadius: 25,
                  height: 70.h,
                  buttonColor: ColorPallette.blackColor,
                  childWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorPallette.whiteColor,
                      ),
                      10.horizontalSpace,
                      Text("Address",
                          style: FontPallette.headingStyle
                              .copyWith(color: ColorPallette.whiteColor)),
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              InkWell(
                onTap: () {
                  confirmationDialog(
                    context: context,
                    content: "Do you want to log out ?",
                    onTap: () {
                      loginProvider.logOut();
                      Navigator.pushReplacementNamed(
                          context, RouteGenerator.loginScreen);
                      mainScreenProvider.reset();
                    },
                  );
                },
                child: SimpleButton(
                  borderRadius: 25,
                  height: 70.h,
                  buttonColor: ColorPallette.blackColor,
                  childWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: ColorPallette.whiteColor,
                      ),
                      10.horizontalSpace,
                      Text("Log Out",
                          style: FontPallette.headingStyle
                              .copyWith(color: ColorPallette.whiteColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
