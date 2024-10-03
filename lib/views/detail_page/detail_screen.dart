import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/product_detail_arguments.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/image_slider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.productDetailArguments});
  final ProductDetailArguments productDetailArguments;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final ProductDetailProvider provider;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        provider = context.read<ProductDetailProvider>();
        provider
            .getVariants(widget.productDetailArguments.product.id ?? "")
            .then(
          (value) {
            provider.getSizes();
            provider.getProductDetails(
                widget.productDetailArguments.product.id ?? "");
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.productDetailArguments.categoryName ?? "";
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
        backgroundColor: ColorPallette.scaffoldBgColor,
        title: Text(
          widget.productDetailArguments.product.name ?? "Product Details",
          style: FontPallette.headingStyle,
        ),
      ),
      backgroundColor: ColorPallette.scaffoldBgColor,
      body: Selector<
          ProductDetailProvider,
          Tuple6<bool, ProductModel?, List<Variant>, Variant?, List<SizeModel>,
              SizeModel?>>(
        selector: (p0, detailProvider) => Tuple6(
            detailProvider.isLoading,
            detailProvider.product,
            detailProvider.variantList,
            detailProvider.variant,
            detailProvider.variantSizes,
            detailProvider.selectedSize),
        builder: (context, value, child) {
          final product = value.item2;
          final isLoading = value.item1;
          final variantList = value.item3;
          final variant = value.item4;
          final sizeList = value.item5;
          final selectedSize = value.item6;
          return isLoading
              ? const LoadingAnimation()
              : ListView(
                  children: [
                    ImageSlider(
                      variant: variant,
                    ),
                    20.verticalSpace,
                    ProductDetailsWidget(
                      categoryName: categoryName,
                      selectedSize: selectedSize,
                      variantList: variantList,
                      variant: variant,
                      product: product,
                    ),
                    10.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.r),
                          child: Text(
                            "Product Variants",
                            style: FontPallette.headingStyle,
                          ),
                        ),
                        SizedBox(
                          height: 130.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: variantList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final variantAtIndex = variantList[index];
                              final isVariant = variantAtIndex.variantId ==
                                  variant?.variantId;
                              return Padding(
                                padding: EdgeInsets.all(10.r),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (!isVariant) {
                                          provider.getVariantDetails(
                                              variantAtIndex.variantId ?? "",
                                              variantAtIndex);
                                        }
                                      },
                                      child: Container(
                                        height: 80.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isVariant
                                                  ? ColorPallette.blackColor
                                                  : ColorPallette.greyColor,
                                              width: isVariant ? 3 : 2),
                                          color: ColorPallette.greyColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: variantList[index]
                                                      .imageUrlList?[0] ??
                                                  ""),
                                        ),
                                      ),
                                    ),
                                    5.verticalSpace,
                                    Text(
                                      variantList[index].color ?? "",
                                      style: FontPallette.headingStyle.copyWith(
                                          fontSize: 13.sp,
                                          color: ColorPallette.darkGreyColor),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 90.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.r),
                                child: Text(
                                  "Sizes",
                                  style: FontPallette.headingStyle,
                                ),
                              ),
                              sizeList.isNotEmpty
                                  ? SizedBox(
                                      height: 60.h,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: sizeList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final isSelectedSize =
                                              selectedSize == sizeList[index];

                                          final size = sizeList[index];
                                          return Padding(
                                            padding: EdgeInsets.all(10.r),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (selectedSize != size) {
                                                      provider.selectSize(size);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    width: 70.w,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: isSelectedSize
                                                              ? ColorPallette
                                                                  .blackColor
                                                              : ColorPallette
                                                                  .greyColor,
                                                          width: isSelectedSize
                                                              ? 3
                                                              : 3),
                                                      color: isSelectedSize
                                                          ? ColorPallette
                                                              .blackColor
                                                          : ColorPallette
                                                              .whiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        size.size,
                                                        style: FontPallette
                                                            .headingStyle
                                                            .copyWith(
                                                                fontSize: 12.sp,
                                                                color: isSelectedSize
                                                                    ? ColorPallette
                                                                        .whiteColor
                                                                    : ColorPallette
                                                                        .blackColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      height: 50.h,
                                    ),
                            ],
                          ),
                        ),
                        5.verticalSpace,
                        selectedSize?.stock != "0"
                            ? Center(
                                child: Container(
                                  padding: EdgeInsets.all(10.r),
                                  width: 250.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.r),
                                      color: ColorPallette.blackColor),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          height: 30.h,
                                          Assets
                                              .cartLargeMinimalisticSvgrepoCom),
                                      15.horizontalSpace,
                                      Text(
                                        "Add to Cart",
                                        style: FontPallette.headingStyle
                                            .copyWith(
                                                color: ColorPallette.whiteColor,
                                                fontSize: 13.sp),
                                      ),
                                    ],
                                  )),
                                ),
                              )
                            : Center(
                                child: Container(
                                  padding: EdgeInsets.all(10.r),
                                  width: 250.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.r),
                                      color: ColorPallette.blackColor),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          height: 30.h,
                                          Assets
                                              .cartLargeMinimalisticSvgrepoCom),
                                      15.horizontalSpace,
                                      Text(
                                        "Out of Stock",
                                        style: FontPallette.headingStyle
                                            .copyWith(
                                                color: ColorPallette.whiteColor,
                                                fontSize: 13.sp),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                        20.verticalSpace
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
