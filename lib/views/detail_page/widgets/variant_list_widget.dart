import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class VariantListView extends StatelessWidget {
  const VariantListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductDetailProvider>();
    return SizedBox(
      height: 130.h,
      child: Selector<ProductDetailProvider, Tuple2<List<Variant>, Variant?>>(
        selector: (p0, p1) => Tuple2(p1.variantList, p1.variant),
        builder: (context, value, child) {
          final variantList = value.item1;
          final variant = value.item2;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: variantList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final variantAtIndex = variantList[index];
              final isVariant = variantAtIndex.variantId == variant?.variantId;
              return Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!isVariant) {
                          provider.getVariantDetails(
                              variantAtIndex.variantId ?? "", variantAtIndex);
                        }
                      },
                      child: Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isVariant
                                  ? ColorPallette.blackColor
                                  : ColorPallette.greyColor,
                              width: isVariant ? 3 : 2),
                          color: ColorPallette.greyColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  variantList[index].imageUrlList?[0] ?? ""),
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      variantList[index].color ?? "",
                      style: FontPallette.headingStyle.copyWith(
                          fontSize: 13.sp, color: ColorPallette.darkGreyColor),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
