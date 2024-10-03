
import 'package:ecommerce_user_side/models/category_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryListview extends StatelessWidget {
  const CategoryListview({
    super.key,
    required this.categoryList,
  });

  final List<CategoryModel> categoryList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: categoryList.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.only(top: 15.h),
              itemCount: categoryList.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorPallette.blackColor,
                        borderRadius: BorderRadius.circular(15)),
                    height: 80.h,
                    width: 300.w,
                    child: Center(
                      child: Text(
                        categoryList[index].categoryName ?? "",
                        maxLines: 2,
                        style: FontPallette.headingStyle.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: ColorPallette.whiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                " No Category found add One",
                style: FontPallette.headingStyle.copyWith(fontSize: 15.sp),
              ),
            ),
    );
  }
}
