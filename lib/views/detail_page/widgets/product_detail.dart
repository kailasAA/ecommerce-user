import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({
    super.key,
    this.variant,
    this.product,
    required this.variantList,
    this.selectedSize,
    required this.categoryName,
  });

  final Variant? variant;
  final ProductModel? product;
  final List<Variant> variantList;
  final SizeModel? selectedSize;
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
    final selectedSize = widget.selectedSize;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product?.name ?? "",
            style: FontPallette.headingStyle,
          ),
          5.verticalSpace,
          Text(
            "Brand : ${widget.product?.brandName ?? ""}",
            style: FontPallette.headingStyle
                .copyWith(fontSize: 13.sp, color: ColorPallette.darkGreyColor),
          ),
          5.verticalSpace,
          Text(
            "Category : ${widget.categoryName}",
            style: FontPallette.headingStyle
                .copyWith(fontSize: 13.sp, color: ColorPallette.darkGreyColor),
          ),
          5.verticalSpace,
          Text(
            "Color : ${widget.variant?.color ?? ""}",
            style: FontPallette.headingStyle
                .copyWith(fontSize: 13.sp, color: ColorPallette.darkGreyColor),
          ),
          5.verticalSpace,
          Text(
            "Price : ₹${selectedSize?.sellingPrice ?? "0"}",
            style: FontPallette.headingStyle
                .copyWith(fontSize: 13.sp, color: ColorPallette.darkGreyColor),
          ),
          5.verticalSpace,
          Text(
            "Discount Price : ₹${selectedSize?.discountPrice ?? "0"}",
            style: FontPallette.headingStyle
                .copyWith(fontSize: 13.sp, color: ColorPallette.darkGreyColor),
          ),
          5.verticalSpace,
          selectedSize?.stock != "0"
              ? Text(
                  "In stock",
                  style: FontPallette.headingStyle.copyWith(
                      fontSize: 13.sp, color: ColorPallette.greenColor),
                )
              : Text(
                  "Out of stock",
                  style: FontPallette.headingStyle
                      .copyWith(fontSize: 13.sp, color: ColorPallette.redColor),
                ),
        ],
      ),
    );
  }
}
