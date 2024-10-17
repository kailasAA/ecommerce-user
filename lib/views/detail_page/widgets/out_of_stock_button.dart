import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OutOfStockButton extends StatelessWidget {
  const OutOfStockButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.r),
        width: 250.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            color: ColorPallette.blackColor),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                height: 30.h, Assets.cartLargeMinimalisticSvgrepoCom),
            15.horizontalSpace,
            Text(
              "Out of Stock",
              style: FontPallette.headingStyle
                  .copyWith(color: ColorPallette.whiteColor, fontSize: 13.sp),
            ),
          ],
        )),
      ),
    );
  }
}