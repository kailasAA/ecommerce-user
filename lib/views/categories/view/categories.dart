import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/category_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/categories/view/widgets/catgeory_listview.dart';
import 'package:ecommerce_user_side/views/categories/view_model.dart/catgeory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:tuple/tuple.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        context.read<CatgeoryProvider>().getCategories();
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Categories", style: FontPallette.headingStyle),
      ),
      body: Selector<CatgeoryProvider, Tuple2<bool, List<CategoryModel>>>(
        selector: (context, provider) =>
            Tuple2(provider.getCategoryLoading, provider.categoryList),
        builder: (context, value, child) {
          final isLoading = value.item1;
          final categoryList = value.item2;
          return isLoading
              ? Center(
                  child: SizedBox(
                      height: 30.h,
                      width: 30.w,
                      child: const LoadingAnimationStaggeredDotsWave()))
              : CategoryListview(categoryList: categoryList);
        },
      ),
    );
  }
}
