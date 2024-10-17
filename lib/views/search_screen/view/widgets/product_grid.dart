
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/views/home/view/widgets/home_products_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.variantList,
    required this.sizeList,
  });

  final List<ProductModel> products;
  final List<Variant> variantList;
  final List<SizeModel> sizeList;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          final variants = variantList
              .where(
                (element) => element.productId == product.id,
              )
              .toList();
          final variant = variants[0];
          final sizes = sizeList.where(
            (size) {
              return size.variantId == variant.variantId;
            },
          ).toList();
          return ProductTile(
              height: 270.h,
              sizes: sizes,
              imageHeight: 100.w,
              width: 165.w,
              product: product,
              variant: variant);
        },
        childCount: products.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 240.h,
        crossAxisCount: 2,
      ),
    );
  }
}
