class ProductModel {
  String? id;
  String? name;
  String? brandName;
  String? categoryId;
  String? categoryName;


  ProductModel({
    this.id,
    this.brandName,
    this.name,
    this.categoryName,
    this.categoryId,

  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data["id"],
      brandName: data["brand_name"],
      categoryId: data["category_id"],
      name: data['name'],
      categoryName: data['category_name'],

    );
  }

}
