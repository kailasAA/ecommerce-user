import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/models/category_model.dart';
import 'package:flutter/cupertino.dart';

class CatgeoryProvider extends ChangeNotifier {
  String selectedCategory = "";
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController? categoryEditingController;
  bool getCategoryLoading = false;
  bool addCatgeoryLoading = false;
  List<CategoryModel> categoryList = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void clearControllers() {
    categoryNameController.clear();
    notifyListeners();
  }

  List<CategoryModel> convertToCategory(List<DocumentSnapshot> docs) {
    return docs.map(
      (doc) {
        return CategoryModel.fromFirestore(doc);
      },
    ).toList();
  }

  // to  get categories

  Future<void> getCategories() async {
    getCategoryLoading = true;
    notifyListeners();
    // categoryList = [];
    try {
      var data = await _firestore.collection("categories").get();
      var list = data.docs;
      categoryList = convertToCategory(list);
      getCategoryLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      getCategoryLoading = false;
      notifyListeners();
    }
  }

  // to change the selected category

  void changeSelectedCategory(String categoryName) {
    categoryEditingController = TextEditingController(text: categoryName);
    selectedCategory = categoryName;
    notifyListeners();
  }
}
