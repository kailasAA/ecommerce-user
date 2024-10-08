import 'package:ecommerce_user_side/models/cart_model.dart';

class ConfirmOrderArguments {
  List<CartModel> cartList;
  ConfirmOrderArguments({required this.cartList});
}
