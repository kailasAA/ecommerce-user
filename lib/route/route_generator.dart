import 'package:ecommerce_user_side/route/argument_models.dart/product_detail_arguments.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/search_screen_arguments.dart';
import 'package:ecommerce_user_side/views/auth/auth.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:ecommerce_user_side/views/auth/sign_up/view/sign_up_screen.dart';
import 'package:ecommerce_user_side/views/detail_page/detail_screen.dart';
import 'package:ecommerce_user_side/views/main_screen/view/main_screen.dart';
import 'package:ecommerce_user_side/views/search_screen/view/search_screen.dart';
import 'package:ecommerce_user_side/views/splash/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  RouteGenerator._privateConstructor();

  static final RouteGenerator _instance = RouteGenerator._privateConstructor();

  factory RouteGenerator() {
    return _instance;
  }

  static const initial = "/";
  static const mainScreen = "mainScreen";
  static const detailScreen = "detailScreen";
  static const loginScreen = "loginScreen";
  static const signUpScreen = "signUpScreen";
  static const authScreen = "authScreen";
  static const addVariantScreen = "addVariantScreen";
  static const addSizeScreen = "addSizeScreen";
  static const searchScreen = "searchScreen";
  static const addOrderScreen = "addOrderScreen";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case initial:
        return buildRoute(settings, const SplashScreen());
      case mainScreen:
        return buildRoute(settings, const MainScreen());
      case detailScreen:
        return buildRoute(
            settings,
            DetailScreen(
                productDetailArguments: arguments as ProductDetailArguments));

      case searchScreen:
        return buildRoute(
            settings,
            SearchScreen(
              searchScreenArguments: arguments as SearchScreenArguments,
            ));
      case loginScreen:
        return buildRoute(settings, const LoginScreen());
      case signUpScreen:
        return buildRoute(settings, const SignUpScreen());
      case authScreen:
        return buildRoute(settings, const AuthCheck());
      default:
        return buildRoute(settings, const SplashScreen());
    }
  }

  static Route buildRoute(RouteSettings settings, Widget widget,
      {bool cupertinoPageRoute = true}) {
    return cupertinoPageRoute
        ? CupertinoPageRoute(builder: (context) => widget, settings: settings)
        : MaterialPageRoute(builder: (context) => widget, settings: settings);
  }
}
