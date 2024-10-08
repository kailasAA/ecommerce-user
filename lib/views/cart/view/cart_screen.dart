import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/common/common_functions.dart/dialog_box.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/confirm_order_arguments.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:ecommerce_user_side/views/cart/view_model/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    context.read<CartProvider>().getCartItems(userId: user?.uid ?? "");
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: ColorPallette.scaffoldBgColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Cart",
          style: FontPallette.headingStyle,
        ),
      ),
      body: Selector<CartProvider, Tuple2<bool, List<CartModel>>>(
        selector: (p0, p1) => Tuple2(p1.isLoading, p1.cartList),
        builder: (context, value, child) {
          final cartList = value.item2;
          final isLoading = value.item1;

          return isLoading
              ? const LoadingAnimation()
              : cartList.isEmpty
                  ? Center(
                      child: Text(
                        "Cart is Empty",
                        style: FontPallette.headingStyle,
                      ),
                    )
                  : Stack(
                      children: [
                        ListView.separated(
                          separatorBuilder: (context, index) =>
                              10.verticalSpace,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 15.r),
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartList[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.r, vertical: 20.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.r),
                                  color:
                                      const Color.fromARGB(255, 105, 104, 104)),
                              child: Padding(
                                padding: EdgeInsets.all(10.r),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.w),
                                      child: CachedNetworkImage(
                                        imageUrl: cartItem.imageUrl ?? '',
                                        height: 70.h,
                                        width: 70.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.productName ?? '',
                                          style: FontPallette.headingStyle
                                              .copyWith(
                                                  fontSize: 14.sp,
                                                  color:
                                                      ColorPallette.whiteColor),
                                        ),
                                        Text(
                                          "Color: ${cartItem.variantColor ?? ""}",
                                          style: FontPallette.headingStyle
                                              .copyWith(
                                                  fontSize: 13.sp,
                                                  color:
                                                      ColorPallette.whiteColor),
                                        ),
                                        Text(
                                          "Size: ${cartItem.size}",
                                          style: FontPallette.headingStyle
                                              .copyWith(
                                                  fontSize: 13.sp,
                                                  color:
                                                      ColorPallette.whiteColor),
                                        ),
                                        Text(
                                          "₹${cartItem.price}",
                                          style: FontPallette.headingStyle
                                              .copyWith(
                                                  fontSize: 13.sp,
                                                  color:
                                                      ColorPallette.whiteColor),
                                        ),
                                      ],
                                    ),

                                    // Remove Button
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            confirmationDialog(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  context
                                                      .read<CartProvider>()
                                                      .removeItem(
                                                          userId:
                                                              user?.uid ?? '',
                                                          cartItem: cartItem);
                                                },
                                                context: context,
                                                content:
                                                    "Do you want remove this ?");
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<CartProvider>()
                                                    .decreaseQuantity(
                                                        userId: user?.uid ?? '',
                                                        cartItem: cartItem);
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: ColorPallette.whiteColor,
                                                size: 35,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Center(
                                                child: Text(
                                                  '${cartItem.quantity}',
                                                  style: FontPallette
                                                      .headingStyle
                                                      .copyWith(
                                                          fontSize: 16.sp,
                                                          color: ColorPallette
                                                              .whiteColor),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<CartProvider>()
                                                    .increaseQuantity(
                                                        userId: user?.uid ?? '',
                                                        cartItem: cartItem);
                                              },
                                              icon: Icon(
                                                Icons.add_circle,
                                                size: 35,
                                                color: ColorPallette.whiteColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteGenerator.confirmOrderScreen,
                                    arguments: ConfirmOrderArguments(
                                        cartList: cartList));
                              },
                              child: SimpleButton(
                                  buttonColor: ColorPallette.blackColor,
                                  width: 150.w,
                                  borderRadius: 25.r,
                                  height: 50.h,
                                  childWidget: Text(
                                    "Order",
                                    style: FontPallette.headingStyle.copyWith(
                                        color: ColorPallette.whiteColor,
                                        fontSize: 14.sp),
                                  )),
                            ),
                          ),
                        )
                      ],
                    );
        },
      ),
    );
  }
}
