
import 'package:ecommerce_user_side/models/size_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SizeListView extends StatelessWidget {
  const SizeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider, Tuple2<List<SizeModel>, SizeModel?>>(
      selector: (p0, p1) => Tuple2(p1.variantSizes, p1.selectedSize),
      builder: (context, value, child) {
        final sizeList = value.item1;
        final selectedSize = value.item2;
        return SizedBox(
          height: 60.h,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sizeList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final isSelectedSize = selectedSize == sizeList[index];

              final size = sizeList[index];
              return sizeList.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (selectedSize != size) {
                                provider.selectSize(size);
                              }
                            },
                            child: Container(
                              height: 30.h,
                              width: 70.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isSelectedSize
                                        ? ColorPallette.blackColor
                                        : ColorPallette.greyColor,
                                    width: isSelectedSize ? 3 : 3),
                                color: isSelectedSize
                                    ? ColorPallette.blackColor
                                    : ColorPallette.whiteColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  size.size,
                                  style: FontPallette.headingStyle.copyWith(
                                      fontSize: 12.sp,
                                      color: isSelectedSize
                                          ? ColorPallette.whiteColor
                                          : ColorPallette.blackColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 50.h,
                    );
            },
          ),
        );
      },
    );
  }
}
