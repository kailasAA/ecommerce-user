import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/common_widgets/textform_field.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:ecommerce_user_side/views/auth/sign_up/view_model/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final signUpProvider = context.read<SignupProvider>();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorPallette.scaffoldBgColor,
          title: Text(
            "Sign Up",
            style: FontPallette.headingStyle,
          ),
        ),
        backgroundColor: ColorPallette.scaffoldBgColor,
        body: Selector<SignupProvider, Tuple2>(
          selector: (p0, p1) => Tuple2(p1.isLoading, p1.isObscure),
          builder: (context, value, child) {
            bool isLoading = value.item1;
            bool isObscure = value.item2;
            return isLoading
                ? const LoadingAnimation()
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 15.r),
                    children: [
                        180.verticalSpace,
                        NuemorphicTextField(
                          textEditingController: emailController,
                          headingText: "E-mail",
                          hintText: "Please enter your emailAdress",
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          onChanged: (p0) {},
                        ),
                        20.verticalSpace,
                        NuemorphicTextField(
                          suffixIcon: IconButton(
                              onPressed: () {
                                signUpProvider.changeObscure();
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
                        20.verticalSpace,
                        NuemorphicTextField(
                          suffixIcon: IconButton(
                              onPressed: () {
                                signUpProvider.changeObscure();
                              },
                              icon: Icon(isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          textEditingController: confirmPasswordController,
                          headingText: "Confirm Password",
                          hintText: "Please confirm your password",
                          keyboardType: TextInputType.text,
                          obscureText: isObscure,
                          onChanged: (p0) {},
                        ),
                        40.verticalSpace,
                        InkWell(
                          onTap: () async {
                            if (passwordController.text ==
                                    confirmPasswordController.text &&
                                confirmPasswordController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                emailController.text.isNotEmpty) {
                              try {
                                await signUpProvider.signUpWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                    context);
                                emailController.clear();
                                passwordController.clear();
                                confirmPasswordController.clear();
                                // Navigator.pushNamed(
                                //     context, RouteGenerator.mainScreen);
                              } catch (e) {
                                print(e.toString());
                              }
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              showToast("Passwords doesn't match",
                                  toastColor: ColorPallette.redColor);
                            } else {
                              showToast("Please fill all the fields",
                                  toastColor: ColorPallette.redColor);
                            }
                          },
                          child: SimpleButton(
                            height: 50,
                            buttonColor: ColorPallette.blackColor,
                            borderRadius: 15,
                            childWidget: Text(
                              "Sign Up",
                              style: FontPallette.headingStyle
                                  .copyWith(color: ColorPallette.whiteColor),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteGenerator.loginScreen);
                            },
                            child: SizedBox(
                              height: 20.h,
                              child: Center(
                                child: Text(
                                  "Already have an account? Log in here!",
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
