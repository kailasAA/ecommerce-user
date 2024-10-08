import 'package:ecommerce_user_side/views/confirm_order_screen/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  bool isLoading = false;
  List<OrderModel> orderList = [];
  OrderModel? order;

  Future<void> addOrders() async {}

  Future<void> getOrders() async {}

  
}
