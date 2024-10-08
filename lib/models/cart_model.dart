class CartModel {
  String? userId;
  String? productId;
  String? categoryId;
  String? variantId;
  String? sizeId;
  String? categoryName;
  String? productName;
  String? variantColor;
  String? size;
  String? price;
  int? quantity;
  String? imageUrl;
  String? brandName;

  CartModel(
      {this.userId,
      this.productId,
      this.categoryId,
      this.variantId,
      this.sizeId,
      this.categoryName,
      this.productName,
      this.variantColor,
      this.size,
      this.price,
      this.quantity,
      this.imageUrl,
      this.brandName});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'categoryId': categoryId,
      'variantId': variantId,
      'sizeId': sizeId,
      'categoryName': categoryName,
      'productName': productName,
      'variantColor': variantColor,
      'size': size,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'brandName': brandName
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        userId: json['userId'],
        productId: json['productId'],
        categoryId: json['categoryId'],
        variantId: json['variantId'],
        sizeId: json['sizeId'],
        categoryName: json['categoryName'],
        productName: json['productName'],
        variantColor: json['variantColor'],
        size: json['size'],
        price: json['price'],
        quantity: json['quantity'],
        imageUrl: json['imageUrl'],
        brandName: json['brandName']);
  }
}
