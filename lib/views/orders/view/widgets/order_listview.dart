import 'package:ecommerce_user_side/common_widgets/cache_image.dart';
import 'package:ecommerce_user_side/models/order_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({
    super.key,
    required this.orderList,
  });

  final List<OrderModel> orderList;

  @override
  Widget build(BuildContext context) {
    return orderList.isEmpty
        ? Center(
            child: Text(
              "No orders placed",
              style: FontPallette.headingStyle,
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (context, index) => 10.verticalSpace,
            padding: EdgeInsets.all(10.r),
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final order = orderList[index];
              String formattedDate = DateFormat('dd-MM-yyyy')
                  .format(order.orderDate ?? DateTime.now());
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ColorPallette.blackColor),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        separatorBuilder: (context, index) => 10.verticalSpace,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.cartItems?.length ?? 0,
                        itemBuilder: (context, itemIndex) {
                          final cartItem = order.cartItems![itemIndex];

                          return Row(
                            children: [
                              SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child: CacheImageNetwork(
                                  imageUrl: cartItem.imageUrl ?? "",
                                  height: 60.h,
                                  width: 60.w,
                                ),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.productName ?? '',
                                      style: FontPallette.headingStyle.copyWith(
                                        fontSize: 14,
                                        color: ColorPallette.whiteColor,
                                      ),
                                    ),
                                    Text(
                                      'Qty: ${cartItem.quantity}',
                                      style: FontPallette.headingStyle.copyWith(
                                        fontSize: 14,
                                        color: ColorPallette.whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${cartItem.price}',
                                style: FontPallette.headingStyle.copyWith(
                                  fontSize: 14,
                                  color: ColorPallette.whiteColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      15.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Date: $formattedDate',
                            style: FontPallette.headingStyle.copyWith(
                              fontSize: 14,
                              color: ColorPallette.whiteColor,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            'Total Price: ₹${order.totalPrice}',
                            style: FontPallette.headingStyle.copyWith(
                              fontSize: 14,
                              color: ColorPallette.whiteColor,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            'Shipping Address: ${order.address?.addressLine ?? ""}, ${order.address?.city ?? ""}, ${order.address?.state ?? ""}',
                            style: FontPallette.headingStyle.copyWith(
                              fontSize: 14,
                              color: ColorPallette.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
