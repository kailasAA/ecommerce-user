import 'package:ecommerce_user_side/models/product_model.dart';


class ProductDetailArguments {
  String categoryId;
  ProductModel product;
  String? categoryName;
  ProductDetailArguments(
      {required this.categoryId,
      required this.product,
      required this.categoryName});
}
