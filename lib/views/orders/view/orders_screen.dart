import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/order_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/confirm_order_screen/view_model/order_provider.dart';
import 'package:ecommerce_user_side/views/orders/view/widgets/order_listview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        context.read<OrderProvider>().getOrders(userId: user?.uid ?? "");
      },
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
          title: Text(
            "Orders",
            style: FontPallette.headingStyle,
          ),
        ),
        body: Selector<OrderProvider, Tuple2<bool, List<OrderModel>>>(
          selector: (p0, p1) => Tuple2(p1.isLoading, p1.orderList),
          builder: (context, value, child) {
            final isLoading = value.item1;
            final orderList = value.item2;
            return isLoading
                ? const LoadingAnimation()
                : OrderListView(orderList: orderList);
          },
        ));
  }
}
