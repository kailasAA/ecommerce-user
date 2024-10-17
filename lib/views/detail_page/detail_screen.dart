import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/product_detail_arguments.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/cart/view_model/cart_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/add_to_cart_button.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/image_slider.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/product_detail.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/size_list_widget.dart';
import 'package:ecommerce_user_side/views/detail_page/widgets/variant_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
        context
            .read<ProductDetailProvider>()
            .getWishlistItems(userId: user?.uid ?? "");
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

