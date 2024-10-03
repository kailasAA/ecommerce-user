import 'package:ecommerce_user_side/views/auth/login/view_model/login_provider.dart';
import 'package:ecommerce_user_side/views/auth/sign_up/view_model/signup_provider.dart';
import 'package:ecommerce_user_side/views/categories/view_model.dart/catgeory_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:ecommerce_user_side/views/home/view_model/home_provider.dart';
import 'package:ecommerce_user_side/views/main_screen/viemodel/main_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Multiproviders {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(
      create: (context) => MainScreenProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProductDetailProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CatgeoryProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => LoginProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => SignupProvider(),
    ),
  ];
}
