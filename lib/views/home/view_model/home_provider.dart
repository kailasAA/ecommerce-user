import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/models/category_model.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Variant> variantList = [];
  List<ProductModel> searchedProducts = [];
  List<SizeModel> sizeList = [];
  List<ProductModel> categoryProducts = [];
  void changeSearchedProducts(List<ProductModel> products) {
    searchedProducts = products;
    notifyListeners();
  }

// to get all the categories
  Future<void> getCategories() async {
    try {
      isLoading = true;
      categoryList = [];
      var data = await firestore.collection("categories").get();
      var list = data.docs;
      final categories = list.map(
        (category) {
          return CategoryModel.fromFirestore(category);
        },
      ).toList();
      categoryList = categories;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  // to get all the products
  Future<void> getCategoryProducts(String categoryId) async {
    isLoading = true;
    notifyListeners();
    try {
      categoryProducts = [];

      var data = await firestore
          .collection("products")
          .where("category_id", isEqualTo: categoryId)
          .get();
      var list = data.docs;
      categoryProducts = list
          .map(
            (product) => ProductModel.fromMap(product.data()),
          )
          .toList();
      isLoading = false;
      notifyListeners();
      print(categoryProducts);
      print("product fetched successfully");
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

// to get all the products
  Future<void> getAllProducts() async {
    try {
      isLoading = true;
      var data = await firestore.collection("products").get();
      var list = data.docs;
      productList = list
          .map(
            (product) => ProductModel.fromMap(product.data()),
          )
          .toList();
      isLoading = false;
      notifyListeners();
      print("product fetched successfully");
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

// to get all the variants
  Future<void> getAllVariants() async {
    try {
      isLoading = true;
      var data = await firestore.collection("variants").get();
      final list = data.docs;
      final allVariants = list.map(
        (variant) {
          return Variant.fromMap(variant.data());
        },
      ).toList();
      variantList = [];
      variantList = allVariants;
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
  Future<void> getAllSizes() async {
    try {
      isLoading = true;
      // notifyListeners();
      final data = await firestore.collection("sizes").get();
      final sizeData = data.docs;
      final allSizes = sizeData.map(
        (size) {
          return SizeModel.fromMap(size.data());
        },
      ).toList();

      sizeList = [];
      sizeList = allSizes;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("size was not fetched $e");
      isLoading = false;
      notifyListeners();
    }
  }
}
