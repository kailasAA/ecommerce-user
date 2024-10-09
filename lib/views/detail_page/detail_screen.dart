import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/product_detail_arguments.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/cart/view_model/cart_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/image_slider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/product_detail.dart';
import 'package:ecommerce_user_side/views/main_screen/viemodel/main_screen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  User? user;
  late final ProductDetailProvider provider;
  late final CartProvider cartProvider;

  void getSizesAndVariants() async {
    provider = context.read<ProductDetailProvider>();
    cartProvider = context.read<CartProvider>();
    final isSuccess = await provider
        .getVariants(widget.productDetailArguments.product.id ?? "");
    if (isSuccess) {
      provider.getSizes();
      provider
          .getProductDetails(widget.productDetailArguments.product.id ?? "");
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getSizesAndVariants();
        cartProvider.getCartItems(userId: user?.uid ?? "");
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
      body: Selector<ProductDetailProvider, bool>(
        selector: (p0, detailProvider) => detailProvider.isLoading,
        builder: (context, value, child) {
          final isLoading = value;
          return isLoading
              ? const LoadingAnimation()
              : ListView(
                  children: [
                    ImageSlider(
                      productId: widget.productDetailArguments.product.id ?? "",
                      user: user,
                    ),
                    20.verticalSpace,
                    ProductDetailsWidget(
                      categoryName: categoryName,
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
                        const VariantListView(),
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
                              const SizeListView()
                            ],
                          ),
                        ),
                        5.verticalSpace,
                        AddToCartButton(categoryName: categoryName, user: user),
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

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.categoryName,
    required this.user,
  });

  final String categoryName;
  final User? user;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    return Selector2<ProductDetailProvider, CartProvider,
        Tuple4<SizeModel?, ProductModel?, Variant?, List<CartModel>>>(
      selector: (p0, p1, p2) =>
          Tuple4(p1.selectedSize, p1.product, p1.variant, p2.cartList),
      builder: (context, value, child) {
        final product = value.item2;
        final selectedSize = value.item1;
        final variant = value.item3;
        final cartList = value.item4;
        bool isInCart =
            cartList.any((cartItem) => cartItem.sizeId == selectedSize?.sizeId);
        if (isInCart) {
          return GestureDetector(
            onTap: () {
              context.read<MainScreenProvider>().updateIndex(2);
              context.read<MainScreenProvider>().navigateToCartScreen();
              Navigator.popUntil(context, (route) {
                print(route.settings.name);
                return route.settings.name == RouteGenerator.authScreen;
              });
            },
            child: Center(
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
                        height: 30.h, Assets.cartLargeMinimalisticSvgrepoCom),
                    15.horizontalSpace,
                    Text(
                      "Go to Cart",
                      style: FontPallette.headingStyle.copyWith(
                          color: ColorPallette.whiteColor, fontSize: 13.sp),
                    ),
                  ],
                )),
              ),
            ),
          );
        }
        return selectedSize?.stock != "0"
            ? InkWell(
                onTap: () {
                  cartProvider.addToCart(CartModel(
                      categoryId: selectedSize?.categoryId ?? "",
                      categoryName: categoryName,
                      imageUrl: (variant?.imageUrlList ?? []).isNotEmpty
                          ? (variant?.imageUrlList?[0] ?? "")
                          : "",
                      price: selectedSize?.discountPrice ?? "",
                      productId: selectedSize?.productId ?? "",
                      productName: product?.name ?? "",
                      quantity: 1,
                      size: selectedSize?.size ?? "",
                      sizeId: selectedSize?.sizeId ?? "",
                      userId: user?.uid ?? "",
                      variantColor: variant?.color ?? "",
                      variantId: variant?.variantId ?? "",
                      brandName: product?.brandName ?? ""));
                  cartProvider.getCartItems(userId: user?.uid ?? "");
                },
                child: Center(
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
                            Assets.cartLargeMinimalisticSvgrepoCom),
                        15.horizontalSpace,
                        Text(
                          "Add to Cart",
                          style: FontPallette.headingStyle.copyWith(
                              color: ColorPallette.whiteColor, fontSize: 13.sp),
                        ),
                      ],
                    )),
                  ),
                ),
              )
            : const OutOfStockButton();
      },
    );
  }
}

class OutOfStockButton extends StatelessWidget {
  const OutOfStockButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
                height: 30.h, Assets.cartLargeMinimalisticSvgrepoCom),
            15.horizontalSpace,
            Text(
              "Out of Stock",
              style: FontPallette.headingStyle
                  .copyWith(color: ColorPallette.whiteColor, fontSize: 13.sp),
            ),
          ],
        )),
      ),
    );
  }
}

class SizeListView extends StatelessWidget {
  const SizeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider, Tuple2<List<SizeModel>, SizeModel?>>(
      selector: (p0, p1) => Tuple2(p1.variantSizes, p1.selectedSize),
      builder: (context, value, child) {
        final sizeList = value.item1;
        final selectedSize = value.item2;
        return SizedBox(
          height: 60.h,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sizeList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final isSelectedSize = selectedSize == sizeList[index];

              final size = sizeList[index];
              return sizeList.isNotEmpty
                  ? Padding(
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
                                        ? ColorPallette.blackColor
                                        : ColorPallette.greyColor,
                                    width: isSelectedSize ? 3 : 3),
                                color: isSelectedSize
                                    ? ColorPallette.blackColor
                                    : ColorPallette.whiteColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  size.size,
                                  style: FontPallette.headingStyle.copyWith(
                                      fontSize: 12.sp,
                                      color: isSelectedSize
                                          ? ColorPallette.whiteColor
                                          : ColorPallette.blackColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 50.h,
                    );
            },
          ),
        );
      },
    );
  }
}

class VariantListView extends StatelessWidget {
  const VariantListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductDetailProvider>();
    return SizedBox(
      height: 130.h,
      child: Selector<ProductDetailProvider, Tuple2<List<Variant>, Variant?>>(
        selector: (p0, p1) => Tuple2(p1.variantList, p1.variant),
        builder: (context, value, child) {
          final variantList = value.item1;
          final variant = value.item2;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: variantList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final variantAtIndex = variantList[index];
              final isVariant = variantAtIndex.variantId == variant?.variantId;
              return Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!isVariant) {
                          provider.getVariantDetails(
                              variantAtIndex.variantId ?? "", variantAtIndex);
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  variantList[index].imageUrlList?[0] ?? ""),
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      variantList[index].color ?? "",
                      style: FontPallette.headingStyle.copyWith(
                          fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
