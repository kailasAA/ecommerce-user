
import 'package:ecommerce_user_side/route/argument_models.dart/category_product_argeuments.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/category_products/view/widgets/product_grid_view.dart';
import 'package:ecommerce_user_side/views/home/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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
    SchedulerBinding.instance.addPostFrameCallback(
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



