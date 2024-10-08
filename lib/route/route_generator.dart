import 'package:ecommerce_user_side/route/argument_models.dart/category_product_argeuments.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/confirm_order_arguments.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/product_detail_arguments.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/search_screen_arguments.dart';
import 'package:ecommerce_user_side/views/address/view/add_adress_screen.dart';
import 'package:ecommerce_user_side/views/address/view/adress_screen.dart';
import 'package:ecommerce_user_side/views/auth/auth.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:ecommerce_user_side/views/auth/sign_up/view/sign_up_screen.dart';
import 'package:ecommerce_user_side/views/category_products/view/category_products.dart';
import 'package:ecommerce_user_side/views/confirm_order_screen/view/confirm_order_screen.dart';
import 'package:ecommerce_user_side/views/detail_page/detail_screen.dart';
import 'package:ecommerce_user_side/views/main_screen/view/main_screen.dart';
import 'package:ecommerce_user_side/views/orders/view/orders_screen.dart';
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
  static const searchScreen = "searchScreen";
  static const addAddressScreen = "addAddressScreen";
  static const categoryProductScreen = "categoryProductScreen";
  static const addressScreen = "addressScreen";
  static const confirmOrderScreen = "confirmOrderScreen";
  static const orderScreen = "orderScreen";

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
      case categoryProductScreen:
        return buildRoute(
            settings,
            CategoryProducts(
                categoryProductArgeuments:
                    arguments as CategoryProductArgeuments));
      case addAddressScreen:
        return buildRoute(settings, const AddAdressScreen());
      case addressScreen:
        return buildRoute(settings, const AdressScreen());
      case confirmOrderScreen:
        return buildRoute(
            settings,
            OrderConfirmationScreen(
              confirmOrderArguments: arguments as ConfirmOrderArguments,
            ));
      case orderScreen:
        return buildRoute(settings, const OrdersScreen());
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
