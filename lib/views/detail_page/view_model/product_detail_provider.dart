import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProductDetailProvider extends ChangeNotifier {
  bool isLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<XFile?> pickedXfileList = [];
  List<File> pickedfileList = [];
  ProductModel? product;
  List<Variant> variantList = [];
  Variant? variant;
  List<SizeModel> variantSizes = [];
  SizeModel? selectedSize;

// to get the product details
  Future<void> getProductDetails(String productId) async {
    try {
      product = null;
      isLoading = true;
      notifyListeners();
      var data = await firestore.collection("products").doc(productId).get();
      product = ProductModel.fromMap(data.data() as Map<String, dynamic>);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

// to get the all variants
  Future<void> getVariants(String productId) async {
    try {
      variant = null;
      isLoading = true;
      notifyListeners();
      var data = await firestore.collection("variants").get();
      final list = data.docs;
      final allVariants = list.map(
        (variant) {
          return Variant.fromMap(variant.data());
        },
      ).toList();
      variantList = [];
      variantList = allVariants.where(
        (element) {
          return element.productId == productId;
        },
      ).toList();
      variant = variantList[0];
      isLoading = false;
      notifyListeners();
      print("variant detail fetched successfully");
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

// to get all the sizes
  Future<void> getSizes() async {
    try {
      isLoading = true;
      notifyListeners();
      final data = await firestore.collection("sizes").get();
      final sizeData = data.docs;
      final allSizes = sizeData.map(
        (size) {
          return SizeModel.fromMap(size.data());
        },
      ).toList();

      variantSizes = [];
      variantSizes = allSizes.where(
        (size) {
          return size.variantId == variant?.variantId;
        },
      ).toList();
      if (variantSizes.isEmpty) {
        selectedSize = null;
      }
      selectedSize = variantSizes[0];
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("size was not fetched $e");
      isLoading = false;
      notifyListeners();
    }
  }

// to get the variant details
  Future<void> getVariantDetails(
      String variantId, Variant? selectedVariant) async {
    try {
      isLoading = true;
      notifyListeners();
      variant = selectedVariant;
      variantSizes = [];
      getSizes();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

// to update the selected size
  Future<void> selectSize(SizeModel sizeModel) async {
    try {
      selectedSize = sizeModel;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
