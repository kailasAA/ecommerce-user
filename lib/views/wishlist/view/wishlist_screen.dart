import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:ecommerce_user_side/views/home/view_model/home_provider.dart';
import 'package:ecommerce_user_side/views/search_screen/view/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<ProductDetailProvider>()
            .getWishlistItems(userId: user?.uid ?? "");
        context.read<HomeProvider>().getAllProducts();
        context.read<HomeProvider>().getAllVariants();
        context.read<HomeProvider>().getAllSizes();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPallette.scaffoldBgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorPallette.scaffoldBgColor,
          title: Text(
            "Wishlist",
            style: FontPallette.headingStyle,
          ),
        ),
        body: Selector<HomeProvider, bool>(
          builder: (context, isLoading, child) {
            return isLoading
                ? const LoadingAnimation()
                : CustomScrollView(slivers: [
                    Selector2<
                            HomeProvider,
                            ProductDetailProvider,
                            Tuple4<List<ProductModel>, List<Variant>,
                                List<SizeModel>, List<String>>>(
                        selector: (p0, p1, p2) => Tuple4(p1.productList,
                            p1.variantList, p1.sizeList, p2.wishListIds),
                        builder: (context, value, child) {
                          final wishListIds = value.item4;
                          final productList = value.item1.where(
                            (product) {
                              return wishListIds.contains(product.id);
                            },
                          ).toList();
                          final variantList = value.item2;
                          final sizeList = value.item3;
                          return productList.isEmpty
                              ? SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 350.h,
                                    child: Center(
                                      child: Text(
                                        "No Product Found",
                                        style: FontPallette.headingStyle
                                            .copyWith(fontSize: 15.sp),
                                      ),
                                    ),
                                  ),
                                )
                              : ProductGrid(
                                  products: productList,
                                  variantList: variantList,
                                  sizeList: sizeList);
                        }),
                  ]);
          },
          selector: (p0, p1) => p1.isLoading,
        ));
  }
}
