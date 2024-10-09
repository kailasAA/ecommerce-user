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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<HomeProvider>().getCategories();
        context.read<HomeProvider>().getAllProducts();
        context.read<HomeProvider>().getAllVariants();
        context.read<HomeProvider>().getAllSizes();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AssetGenImage> imageList = [
      Assets.pexels,
      Assets.pexelsAlexandr,
      Assets.pexelsThelazyartist
    ];
    return Scaffold(
        backgroundColor: ColorPallette.scaffoldBgColor,
        body: CustomScrollView(
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
                            style: FontPallette.headingStyle
                                .copyWith(color: ColorPallette.blackColor),
                          ),
                        ),
                        Selector<HomeProvider, List<ProductModel>>(
                          selector: (p0, p1) => p1.productList,
                          builder: (context, productList, child) {
                            return InkWell(
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
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  CrouselSection(imageList: imageList),
                  30.verticalSpace,
                ],
              ),
            ),
            const ProductSection()
          ],
        ));
  }
}

class ProductSection extends StatelessWidget {
  const ProductSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<HomeProvider, Tuple4>(selector: (p0, p1) {
      return Tuple4(
          p1.categoryList, p1.productList, p1.variantList, p1.sizeList);
    }, builder: (context, value, child) {
      List<CategoryModel> categoryList = value.item1;
      List<ProductModel> productList = value.item2;
      List<Variant> variantList = value.item3;
      List<SizeModel> sizes = value.item4;
      return productList.isNotEmpty
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categoryList[index];
                  return Column(
                    children: [
                      HomeProductListWithHeading(
                        categoryName: category.categoryName ?? "",
                        variantList: variantList,
                        products: productList
                            .where(
                              (product) => product.categoryId == category.id,
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
                child: const Center(child: LoadingAnimation()),
              ),
            );
    });
  }
}

class CrouselSection extends StatelessWidget {
  const CrouselSection({
    super.key,
    required this.imageList,
  });

  final List<AssetGenImage> imageList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: CarouselView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10.r),
        itemSnapping: true,
        itemExtent: 380.w,
        children: List.generate(
          imageList.length,
          (index) {
            return Container(
              decoration: BoxDecoration(
                color: ColorPallette.scaffoldBgColor,
                borderRadius: BorderRadius.circular(15.r),
                image: DecorationImage(
                  image: imageList[index]
                      .image()
                      .image, // Use image as DecorationImage
                  fit: BoxFit.cover, // Set the fit to cover
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
