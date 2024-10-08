import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/models/address_model.dart';

class OrderModel {
  List<CartModel>? cartItems;
  AddressModel? address;
  String? userName;
  String? totalPrice;
  String? orderId;
  DateTime? orderDate;
  String? userId;

  OrderModel(
      {this.cartItems,
      this.address,
      this.userName,
      this.totalPrice,
      this.orderId,
      this.orderDate,
      this.userId});

  Map<String, dynamic> toJson() {
    return {
      'cartItems': cartItems?.map((item) => item.toJson()).toList(),
      'address': address?.toJson(),
      'userName': userName,
      'totalPrice': totalPrice,
      'orderId': orderId,
      'orderDate': orderDate?.toIso8601String(),
      'userId': userId
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        cartItems: (json['cartItems'] as List?)
            ?.map((item) => CartModel.fromJson(item))
            .toList(),
        address: AddressModel.fromJson(json['address']),
        userName: json['userName'],
        totalPrice: json['totalPrice'],
        orderId: json['orderId'],
        orderDate: json['orderDate'] != null
            ? DateTime.parse(json['orderDate'])
            : null,
        userId: json['userId']);
  }
}
