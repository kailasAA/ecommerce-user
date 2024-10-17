import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isCartQuantityLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<CartModel> cartList = [];
  String updatingCartId = "";

// to add items to cart
  Future<void> addToCart(CartModel cartModel) async {
    try {
      await firestore
          .collection('users')
          .doc(cartModel.userId)
          .collection('cart')
          .add(cartModel.toJson());
      showToast("successfully added to cart", gravity: ToastGravity.CENTER);
    } catch (e) {
      throw Exception("Error adding product to cart: $e");
    }
  }

//  to get the items in the cart
  Future<void> getCartItems({required String userId}) async {
    isLoading = true;
    // notifyListeners();
    try {
      final data = await firestore
          .collection("users")
          .doc(userId)
          .collection("cart")
          .get();
      final doc = data.docs;
      final list = doc.map(
        (cart) {
          return CartModel.fromJson(cart.data());
        },
      ).toList();
      cartList = list;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  // to increase the quantity of the item
  Future<void> increaseQuantity(
      {required String userId, required CartModel cartItem}) async {
    updatingCartId = cartItem.sizeId ?? "";
    isCartQuantityLoading = true;
    notifyListeners();
    try {
      final docRef = await firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .where('sizeId', isEqualTo: cartItem.sizeId)
          .get();

      if (docRef.docs.isNotEmpty) {
        int newQuantity = (cartItem.quantity ?? 1) + 1;
        await docRef.docs.first.reference.update({'quantity': newQuantity});
        showToast("Quantity increased", gravity: ToastGravity.CENTER);

        await getCartItems(userId: userId);
      }
      updatingCartId = "";
      isCartQuantityLoading = false;
      notifyListeners();
    } catch (e) {
      updatingCartId = "";
      isCartQuantityLoading = false;
      notifyListeners();
      showToast(
        "Error increasing quantity: $e",
      );
    }
  }

// to decrease the quantity of the item
  Future<void> decreaseQuantity(
      {required String userId, required CartModel cartItem}) async {
    updatingCartId = cartItem.sizeId ?? "";
    isCartQuantityLoading = true;
    notifyListeners();
    try {
      final docRef = await firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .where('sizeId', isEqualTo: cartItem.sizeId)
          .get();

      if (docRef.docs.isNotEmpty) {
        int currentQuantity = cartItem.quantity ?? 1;
        if (currentQuantity > 1) {
          int newQuantity = currentQuantity - 1;
          await docRef.docs.first.reference.update({'quantity': newQuantity});
          showToast("Quantity decreased", gravity: ToastGravity.CENTER);

          await getCartItems(userId: userId);
        } else {
          showToast("Quantity cannot be less than 1",
              toastColor: Colors.orange, gravity: ToastGravity.CENTER);
        }
      }
      updatingCartId = "";
      isCartQuantityLoading = false;
      notifyListeners();
    } catch (e) {
      updatingCartId = "";
      isCartQuantityLoading = false;
      notifyListeners();
      showToast("Error decreasing quantity: $e",
          toastColor: Colors.red, gravity: ToastGravity.CENTER);
    }
  }

// to remove the item from the cart
  Future<void> removeItem(
      {required String userId, required CartModel cartItem}) async {
    try {
      final docRef = await firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .where('sizeId', isEqualTo: cartItem.sizeId)
          .get();

      if (docRef.docs.isNotEmpty) {
        await docRef.docs.first.reference.delete();
        showToast("Item removed from cart",
            toastColor: ColorPallette.redColor, gravity: ToastGravity.CENTER);

        await getCartItems(userId: userId);
      }
    } catch (e) {
      showToast("Error removing item: $e",
          toastColor: Colors.red, gravity: ToastGravity.CENTER);
    }
  }

  // clear cart
  Future<void> clearCart({required String userId}) async {
    isLoading = true;
    notifyListeners();
    try {
      final cartRef =
          firestore.collection('users').doc(userId).collection('cart');

      final snapshot = await cartRef.get();

      for (var element in snapshot.docs) {
        cartRef.doc(element.id).delete();
      }
      getCartItems(userId: userId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      showToast("Error removing item: $e",
          toastColor: Colors.red, gravity: ToastGravity.CENTER);
    }
  }
}
