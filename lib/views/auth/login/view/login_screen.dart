import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/common_widgets/textform_field.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/auth/login/view_model/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final lognProvider = context.read<LoginProvider>();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorPallette.scaffoldBgColor,
          title: Text(
            "Login",
            style: FontPallette.headingStyle,
          ),
        ),
        backgroundColor: ColorPallette.scaffoldBgColor,
        body: Selector<LoginProvider, Tuple2>(
          selector: (p0, p1) => Tuple2(p1.isLoading, p1.isObscure),
          builder: (context, value, child) {
            bool isLoading = value.item1;
            bool isObscure = value.item2;
            return isLoading
                ? const LoadingAnimation()
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 15.r),
                    children: [
                        230.verticalSpace,
                        NuemorphicTextField(
                          textEditingController: emailController,
                          headingText: "Email",
                          hintText: "Please enter your emailAdress",
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          onChanged: (p0) {},
                        ),
                        20.verticalSpace,
                        NuemorphicTextField(
                          suffixIcon: IconButton(
                              onPressed: () {
                                lognProvider.changeObscure();
                              },
                              icon: Icon(isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          textEditingController: passwordController,
                          headingText: "Password",
                          hintText: "Please enter your password",
                          keyboardType: TextInputType.text,
                          obscureText: isObscure,
                          onChanged: (p0) {},
                        ),
                        40.verticalSpace,
                        InkWell(
                          onTap: () async {
                            try {
                              await lognProvider.loginWithPasswordAndEmail(
                                  emailController.text,
                                  passwordController.text,
                                  context);
                              emailController.clear();
                              passwordController.clear();
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: SimpleButton(
                            height: 50,
                            buttonColor: ColorPallette.blackColor,
                            borderRadius: 15,
                            childWidget: Text(
                              "Login",
                              style: FontPallette.headingStyle
                                  .copyWith(color: ColorPallette.whiteColor),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteGenerator.signUpScreen);
                            },
                            child: SizedBox(
                              height: 20.h,
                              child: Center(
                                child: Text(
                                  "Don't have an account? Sign up now!",
                                  style: FontPallette.headingStyle
                                      .copyWith(fontSize: 13.sp),
                                ),
                              ),
                            ))
                      ]);
          },
        ));
  }
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    this.height,
    this.borderRadius,
    this.childWidget,
    this.buttonColor,
  });
  final double? height;
  final double? borderRadius;
  final Widget? childWidget;
  final Color? buttonColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: ColorPallette.blackColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 15)),
      child: Center(child: childWidget),
    );
  }
}
