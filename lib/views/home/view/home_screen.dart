
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/route/argument_models.dart/search_screen_arguments.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/models/category_model.dart';
import 'package:ecommerce_user_side/models/product_model.dart';
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/views/home/view/widgets/home_products_listview.dart';
import 'package:ecommerce_user_side/views/home/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeProvider>().getCategories();
    context.read<HomeProvider>().getAllProducts();
    context.read<HomeProvider>().getAllVariants();
    context.read<HomeProvider>().getAllSizes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      body: Selector<HomeProvider, Tuple5>(
        selector: (p0, p1) {
          return Tuple5(p1.categoryList, p1.isLoading, p1.productList,
              p1.variantList, p1.sizeList);
        },
        builder: (context, value, child) {
          List<Color> colorlist = [Colors.black, Colors.yellow, Colors.blue];
          final isLoading = value.item2;
          List<CategoryModel> categoryList = value.item1;
          List<ProductModel> productList = value.item3;
          List<Variant> variantList = value.item4;
          List<SizeModel> sizes = value.item5;

          return isLoading
              ? const LoadingAnimationStaggeredDotsWave()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: 30.verticalSpace,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  child: Text(
                                    "Welcome Back",
                                    style: FontPallette.headingStyle.copyWith(
                                        color: ColorPallette.blackColor),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RouteGenerator.searchScreen,
                                        arguments: SearchScreenArguments(
                                            productList: productList));
                                  },
                                  child: SizedBox(
                                      height: 35.h,
                                      width: 35.w,
                                      child: SvgPicture.asset(
                                          Assets.searchAltSvgrepoCom)),
                                )
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          SizedBox(
                            height: 250.h,
                            child: CarouselView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.all(10.r),
                                itemSnapping: true,
                                itemExtent: 380.w,
                                children: List.generate(
                                  colorlist.length,
                                  (index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          color: colorlist[index]),
                                    );
                                  },
                                )),
                          ),
                          30.verticalSpace,
                        ],
                      ),
                    ),
                    productList.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final category = categoryList[index];
                                return Column(
                                  children: [
                                    HomeProductListWithHeading(
                                      categoryName: category.categoryName ?? "",
                                      variantList: variantList,
                                      products:
                                          // productList,
                                          productList
                                              .where(
                                                (product) =>
                                                    product.categoryId ==
                                                    category.id,
                                              )
                                              .toList(),
                                      sizes: sizes.where(
                                        (size) {
                                          return size.categoryId == category.id;
                                        },
                                      ).toList(),
                                      productHeading: category.categoryName,
                                    ),
                                  ],
                                );
                              },
                              childCount: categoryList.length,
                            ),
                          )
                        : SliverToBoxAdapter(
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
                          ),
                  ],
                );
        },
      ),
    );
  }
}
