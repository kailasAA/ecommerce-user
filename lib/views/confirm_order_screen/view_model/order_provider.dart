import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:ecommerce_user_side/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderProvider extends ChangeNotifier {
  bool isLoading = false;
  List<OrderModel> orderList = [];
  OrderModel? order;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addOrders(OrderModel order) async {
    isLoading = true;
    notifyListeners();
    try {
      final docRef = await firestore
          .collection('users')
          .doc(order.userId)
          .collection('orders')
          .add(order.toJson());
      showToast("Order Placed Successfully", gravity: ToastGravity.CENTER);
      isLoading = false;
      notifyListeners();
      final id = docRef.id;
      await firestore
          .collection('users')
          .doc(order.userId)
          .collection('orders')
          .doc(id)
          .update({'orderId': id});
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception("Error placing order: $e");
    }
  }

  Future<void> getOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await firestore
          .collection("users")
          .doc(userId)
          .collection("orders")
          .get();
      final doc = data.docs;
      final list = doc.map(
        (cart) {
          return OrderModel.fromJson(cart.data());
        },
      ).toList();
      orderList = list;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}
