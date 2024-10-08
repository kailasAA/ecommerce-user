import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/views/address/model/address_model.dart';

class OrderModel {
  List<CartModel>? cartItems;
  AddressModel? adress;
  String? userName;
  String? totalPrice;
}
