import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/common_widgets/neumorphic.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/product_detail_arguments.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeProductListWithHeading extends StatelessWidget {
  const HomeProductListWithHeading({
    super.key,
    this.productHeading,
    required this.products,
    required this.variantList,
    required this.categoryName,
    required this.sizes,
  });
  final String? productHeading;
  final List<ProductModel> products;
  final List<Variant> variantList;
  final List<SizeModel> sizes;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty && variantList.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  productHeading ?? "",
                  style: FontPallette.headingStyle,
                ),
              ),
              SizedBox(
                height: 260.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final variants = variantList.where(
                        (element) {
                          return element.productId == product.id;
                        },
                      ).toList();
                      final variant = variants[0];
                      List<SizeModel>? sizeList = sizes.where(
                        // orElse: () => null,
                        (element) {
                          return element.variantId == variant.variantId;
                        },
                      ).toList();
                      return ProductTile(
                        height: 260.h,
                        sizes: sizeList,
                        product: product,
                        variant: variant,
                        categoryName: categoryName,
                      );
                    },
                    // separatorBuilder: (context, index) => 20.horizontalSpace,
                    itemCount: products.length),
              ),
            ],
          )
        : const SizedBox();
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.variant,
    this.height,
    this.width,
    this.imageHeight,
    this.categoryName,
    this.sizes,
  });

  final ProductModel product;
  final Variant variant;
  final double? height;
  final double? width;
  final double? imageHeight;
  final String? categoryName;
  final List<SizeModel>? sizes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteGenerator.detailScreen,
            arguments: ProductDetailArguments(
                categoryName: categoryName,
                categoryId: product.categoryId ?? "",
                product: product));
      },
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: NeumorphicContainer(
          offset: const Offset(2, 2),
          blurRadius: 15.r,
          height: height,
          width: width ?? 160.w,
          childWidget: Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: imageHeight ?? 130.w,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: (variant.imageUrlList ?? []).isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: variant.imageUrlList?[0] ?? "",
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            placeholder: (context, url) => Center(
                                child: LoadingAnimation(
                              size: 20.r,
                            )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(
                            height: 130.w,
                            decoration: BoxDecoration(
                                color: ColorPallette.greyColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                  ),
                ),
                5.verticalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
                      child: Text(
                        product.name ?? "",
                        style:
                            FontPallette.headingStyle.copyWith(fontSize: 13.sp),
                      ),
                    ),
                    Text(
                      product.brandName ?? "",
                      style:
                          FontPallette.headingStyle.copyWith(fontSize: 13.sp),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    (sizes ?? []).isEmpty
                        ? const Row()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Price : ₹${sizes?[0].discountPrice ?? ""}",
                                style: FontPallette.headingStyle
                                    .copyWith(fontSize: 13.sp),
                              ),
                              Text(
                                "Size : ${sizes?[0].size ?? ""}",
                                style: FontPallette.headingStyle
                                    .copyWith(fontSize: 13.sp),
                              ),
                            ],
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
