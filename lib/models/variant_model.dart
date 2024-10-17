class Variant {
  String? variantId;
  String? productId;
  String? color;
  String? categoryId;
  String? categoryName;
  List<String?>? imageUrlList;

  Variant({
    this.variantId,
    this.productId,
    this.color,
    this.categoryId,
    this.categoryName,
    this.imageUrlList,
  });

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      variantId: map['variant_id'],
      productId: map['product_id'],
      color: map['color'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      imageUrlList: List<String>.from(map['image_url'] ?? []),
    );
  }

}
