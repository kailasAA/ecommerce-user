

import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/cart/view_model/cart_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/out_of_stock_button.dart';
import 'package:ecommerce_user_side/views/main_screen/viemodel/main_screen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
              // Navigator.pop(context);
              Navigator.popUntil(context, (route) {
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
