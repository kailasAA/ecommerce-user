import 'package:ecommerce_user_side/common_widgets/neumorphic.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void confirmationDialog(
    {required BuildContext context,
    String? heading,
    String? content,
    void Function()? onTap}) {
  showDialog(
    context: context,
    builder: (context) {
      return SizedBox(
        height: 50.h,
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(15),
            content: Padding(
              padding: EdgeInsets.all(8.h),
              child: Text(
                textAlign: TextAlign.center,
                content ?? "",
                style: FontPallette.headingStyle.copyWith(fontSize: 13.sp),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: onTap,
                        child: NeumorphicContainer(
                            height: 40.h,
                            width: 100.w,
                            childWidget: Center(
                                child: Text(
                              "Yes",
                              style: FontPallette.headingStyle
                                  .copyWith(fontSize: 13.sp),
                            )))),
                    20.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: NeumorphicContainer(
                          height: 40.h,
                          width: 100.w,
                          childWidget: Center(
                              child: Text(
                            'No',
                            style: FontPallette.headingStyle
                                .copyWith(fontSize: 13.sp),
                          ))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
