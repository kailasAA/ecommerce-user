import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/category_product_argeuments.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/home/view/widgets/home_products_listview.dart';
import 'package:ecommerce_user_side/views/home/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({
    super.key,
    required this.categoryProductArgeuments,
  });

  final CategoryProductArgeuments categoryProductArgeuments;
  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context
            .read<HomeProvider>()
            .getCategoryProducts(widget.categoryProductArgeuments.categoryId);
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
        title: Text(
          widget.categoryProductArgeuments.categoryName,
          style: FontPallette.headingStyle.copyWith(),
        ),
        backgroundColor: ColorPallette.scaffoldBgColor,
      ),
      body: const CustomScrollView(
        slivers: [
          ProductGridView(),
        ],
      ),
    );
  }
}




class ProductGridView extends StatelessWidget {
  const ProductGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<HomeProvider,
        Tuple4<List<ProductModel>, List<Variant>, List<SizeModel>, bool>>(
      selector: (p0, p1) => Tuple4(
          p1.categoryProducts, p1.variantList, p1.sizeList, p1.isLoading),
      builder: (context, value, child) {
        final categoryProducts = value.item1;
        final variantList = value.item2;
        final sizeList = value.item3;
        final isLoading = value.item4;
        if (isLoading) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              child: Center(child: LoadingAnimation()),
            ),
          );
        }
        return categoryProducts.isEmpty
            ? SliverToBoxAdapter(
                child: SizedBox(
                  height: 350.h,
                  child: Center(
                    child: Text(
                      "No Product Found",
                      style:
                          FontPallette.headingStyle.copyWith(fontSize: 15.sp),
                    ),
                  ),
                ),
              )
            : SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = categoryProducts[index];
                    final variants = variantList
                        .where(
                          (element) => element.productId == product.id,
                        )
                        .toList();
                    final variant = variants[0];
                    final sizes = sizeList.where(
                      (size) {
                        return size.variantId == variant.variantId;
                      },
                    ).toList();
                    return ProductTile(
                        height: 270.h,
                        sizes: sizes,
                        imageHeight: 100.w,
                        width: 165.w,
                        product: product,
                        variant: variant);
                  },
                  childCount: categoryProducts.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 240.h,
                  crossAxisCount: 2,
                ),
              );
      },
    );
  }
}
