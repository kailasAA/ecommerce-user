import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  late final ProductDetailProvider provider;
  @override
  void initState() {
    provider = context.read<ProductDetailProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider,
        Tuple3<Variant?, ProductModel?, SizeModel?>>(
      selector: (p0, p1) => Tuple3(p1.variant, p1.product, p1.selectedSize),
      builder: (context, value, child) {
        final size = value.item3;
        final product = value.item2;
        final variant = value.item1;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.r),
          child: SizedBox(
            height: 180.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.name ?? "",
                  style: FontPallette.headingStyle,
                ),
                5.verticalSpace,
                Text(
                  "Brand : ${product?.brandName ?? ""}",
                  style: FontPallette.headingStyle.copyWith(
                      fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                ),
                5.verticalSpace,
                Text(
                  "Category : ${widget.categoryName}",
                  style: FontPallette.headingStyle.copyWith(
                      fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                ),
                5.verticalSpace,
                Text(
                  "Color : ${variant?.color ?? ""}",
                  style: FontPallette.headingStyle.copyWith(
                      fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                ),
                5.verticalSpace,
                Text(
                  "Price : ₹${size?.sellingPrice ?? "0"}",
                  style: FontPallette.headingStyle.copyWith(
                      fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                ),
                5.verticalSpace,
                Text(
                  "Discount Price : ₹${size?.discountPrice ?? "0"}",
                  style: FontPallette.headingStyle.copyWith(
                      fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                ),
                5.verticalSpace,
                size?.stock != "0"
                    ? Text(
                        "In stock",
                        style: FontPallette.headingStyle.copyWith(
                            fontSize: 13.sp, color: ColorPallette.greenColor),
                      )
                    : Text(
                        "Out of stock",
                        style: FontPallette.headingStyle.copyWith(
                            fontSize: 13.sp, color: ColorPallette.redColor),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
