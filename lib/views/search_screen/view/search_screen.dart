import 'package:ecommerce_user_side/common_widgets/textform_field.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/search_screen_arguments.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/home/view/widgets/home_products_listview.dart';
import 'package:ecommerce_user_side/views/home/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.searchScreenArguments});
  final SearchScreenArguments searchScreenArguments;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<HomeProvider>().resetProducts();
        context
            .read<HomeProvider>()
            .changeSearchedProducts(widget.searchScreenArguments.productList);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
        backgroundColor: ColorPallette.scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: ColorPallette.scaffoldBgColor,
        ),
        body: CustomScrollView(
          slivers: [
            Selector<HomeProvider, List<ProductModel>>(
                selector: (p0, p1) => p1.productList,
                builder: (context, value, child) {
                  final productList = value;
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(15.r),
                      child: NuemorphicTextField(
                        headingText: "Search",
                        hintText: "Search here",
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final searchedList = productList.where(
                              (product) {
                                return (product.name ?? "")
                                    .toLowerCase()
                                    .startsWith(value.toLowerCase());
                              },
                            ).toList();
                            context
                                .read<HomeProvider>()
                                .changeSearchedProducts(searchedList);
                          } else {
                            context.read<HomeProvider>().resetProducts();
                          }
                        },
                        textEditingController: searchController,
                        prefixWidget: const Icon(Icons.search),
                      ),
                    ),
                  );
                }),
            Selector<
                    HomeProvider,
                    Tuple4<List<ProductModel>, List<ProductModel>,
                        List<Variant>, List<SizeModel>>>(
                selector: (p0, p1) => Tuple4(p1.searchedProducts,
                    p1.productList, p1.variantList, p1.sizeList),
                builder: (context, value, child) {
                  final productList = value.item2;
                  final variantList = value.item3;
                  final searchProducts = value.item1;
                  final sizeList = value.item4;
                  return productList.isEmpty || searchProducts.isEmpty
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
                          products: searchProducts,
                          variantList: variantList,
                          sizeList: sizeList);
                }),
          ],
        ));
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.variantList,
    required this.sizeList,
  });

  final List<ProductModel> products;
  final List<Variant> variantList;
  final List<SizeModel> sizeList;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
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
        childCount: products.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 240.h,
        crossAxisCount: 2,
      ),
    );
  }
}
