import 'package:ecommerce_user_side/models/cart_model.dart';
import 'package:ecommerce_user_side/models/order_model.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:ecommerce_user_side/views/cart/view_model/cart_provider.dart';
import 'package:ecommerce_user_side/views/confirm_order_screen/view_model/order_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:ecommerce_user_side/common_widgets/cache_image.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/confirm_order_arguments.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/models/address_model.dart';
import 'package:ecommerce_user_side/views/address/view_model/address_provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen(
      {super.key, required this.confirmOrderArguments});
  final ConfirmOrderArguments confirmOrderArguments;

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late int totalPrice;
  late User? user;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().getAddress(user?.uid ?? "");
    });
    calculateTotalPrice();
    user = FirebaseAuth.instance.currentUser;
  }

  void calculateTotalPrice() {
    totalPrice = widget.confirmOrderArguments.cartList.fold(0, (sum, item) {
      return sum +
          (int.tryParse(item.price ?? '0') ?? 0) * (item.quantity ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartList = widget.confirmOrderArguments.cartList;
    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: ColorPallette.scaffoldBgColor,
        centerTitle: true,
        title: Text('Order Confirmation', style: FontPallette.headingStyle),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: CustomScrollView(
          slivers: [
            buildCartItemsList(cartList),
            buildAddressList(),
            buildTotalPrice(totalPrice),
            buildConfirmOrderButton(cartList, totalPrice),
          ],
        ),
      ),
    );
  }

  Widget buildAddressList() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          10.verticalSpace,
          Selector<AddressProvider, Tuple2<AddressModel?, List<AddressModel>>>(
            selector: (_, provider) =>
                Tuple2(provider.selectedAdress, provider.addressList),
            builder: (context, value, _) {
              final selectedAddress = value.item1;
              final addressList = value.item2;

              return addressList.isEmpty
                  ? Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        child: Text(
                          "Add new Adress",
                          style: FontPallette.headingStyle
                              .copyWith(fontSize: 12.sp),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.addAddressScreen);
                        },
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select your Adress",
                          style: FontPallette.headingStyle
                              .copyWith(fontSize: 12.sp),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                              color: ColorPallette.greyColor,
                              borderRadius: BorderRadius.circular(15.r)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(10.r),
                            itemCount: addressList.length,
                            itemBuilder: (context, index) {
                              final address = addressList[index];
                              return RadioListTile<String>(
                                selectedTileColor: ColorPallette.blackColor,
                                value: address.id ?? '',
                                groupValue: selectedAddress?.id ?? "",
                                onChanged: (value) {
                                  context
                                      .read<AddressProvider>()
                                      .changeSelectedAdress(address);
                                },
                                title: Text(address.name ?? '',
                                    style: FontPallette.headingStyle
                                        .copyWith(fontSize: 13.sp)),
                                subtitle: Text(
                                    '${address.addressLine}, ${address.city}, ${address.state}, ${address.postalCode}'),
                              );
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCartItemsList(List<CartModel> cartList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cartItem = cartList[index];

          return ListTile(
            leading: CacheImageNetwork(
              imageUrl: cartItem.imageUrl ?? "",
              height: 70.h,
              width: 70.h,
            ),
            title: Text(
              cartItem.productName ?? '',
              style: FontPallette.headingStyle.copyWith(fontSize: 14.sp),
            ),
            subtitle: Text("₹${cartItem.price}"),
            trailing: Text("Quantity: ${cartItem.quantity}"),
          );
        },
        childCount: cartList.length,
      ),
    );
  }

  Widget buildConfirmOrderButton(List<CartModel> cartList, int totalPrice) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Selector<AddressProvider, AddressModel?>(
              selector: (_, provider) => provider.selectedAdress,
              builder: (context, selectedAddress, _) {
                DateTime dateTime = DateTime.now();
                return GestureDetector(
                  onTap: selectedAddress != null
                      ? () {
                          context.read<OrderProvider>().addOrders(OrderModel(
                                address: selectedAddress,
                                cartItems: cartList,
                                orderDate: dateTime,
                                userId: user?.uid ?? "",
                                totalPrice: totalPrice.toString(),
                                userName: user?.email ?? "",
                              ));
                          context
                              .read<CartProvider>()
                              .clearCart(userId: user?.uid ?? "");
                        }
                      : () => showToast("Please select an address"),
                  child: SimpleButton(
                    borderRadius: 25.r,
                    height: 40.h,
                    width: 160.w,
                    buttonColor: ColorPallette.blackColor,
                    childWidget: Text(
                      "Confirm Order",
                      style: FontPallette.headingStyle.copyWith(
                        fontSize: 12.sp,
                        color: ColorPallette.whiteColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildTotalPrice(int totalPrice) {
  return SliverToBoxAdapter(
    child: Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            Text(
              "Total Price:",
              style: FontPallette.headingStyle.copyWith(fontSize: 14.sp),
            ),
            10.horizontalSpace,
            Text(
              "₹$totalPrice",
              style: FontPallette.headingStyle.copyWith(
                fontSize: 14.sp,
                color: ColorPallette.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
