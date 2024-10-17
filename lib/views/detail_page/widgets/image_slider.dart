import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/views/detail_page/view_model/product_detail_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    super.key,
    this.user,
    required this.productId,
  });
  final User? user;
  final String productId;
  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {},
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Selector<ProductDetailProvider, Variant?>(
            selector: (p0, p1) => p1.variant,
            builder: (context, variant, child) {
              return SizedBox(
                height: 250.h,
                child: CarouselView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(10.r),
                    itemSnapping: true,
                    itemExtent: 380.w,
                    children: List.generate(
                      (variant?.imageUrlList ?? []).length,
                      (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: ColorPallette.scaffoldBgColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: variant?.imageUrlList?[index] ?? "",
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorPallette.scaffoldBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Center(
                                  child: LoadingAnimation(
                                size: 20.r,
                              )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    )),
              );
              // SizedBox(
              //   height: 220.h,
              //   width: double.infinity,
              //   child: PageView.builder(
              //     scrollDirection: Axis.horizontal,
              //     controller: pageController,
              //     itemBuilder: (context, index) {
              //       final currentIndex =
              //           index % (variant?.imageUrlList ?? []).length;
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 8),
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 10.r),
              //           child: ClipRRect(
              //             borderRadius: const BorderRadius.vertical(
              //               top: Radius.circular(12),
              //             ),
              //             child: CachedNetworkImage(
              //               imageUrl:
              //                   variant?.imageUrlList?[currentIndex] ?? "",
              //               imageBuilder: (context, imageProvider) {
              //                 return Container(
              //                   width: double.infinity,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     image: DecorationImage(
              //                       image: imageProvider,
              //                       fit: BoxFit.cover,
              //                     ),
              //                   ),
              //                 );
              //               },
              //               placeholder: (context, url) => Center(
              //                   child: LoadingAnimation(
              //                 size: 20.r,
              //               )),
              //               errorWidget: (context, url, error) =>
              //                   const Icon(Icons.error),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // );
            }),
        Positioned(
            top: 15.h,
            right: 15.w,
            child: Selector<ProductDetailProvider, Tuple2<List<String>, bool>>(
              selector: (p0, p1) => Tuple2(p1.wishListIds, p1.wishListLoading),
              builder: (context, value, child) {
                final wishListIds = value.item1;
                final isWishlistLoading = value.item2;
                return isWishlistLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: LoadingAnimation(
                          size: 25.r,
                        )),
                      )
                    : IconButton(
                        onPressed: () {
                          context.read<ProductDetailProvider>().addToWishlist(
                              widget.user?.uid ?? "", widget.productId);
                        },
                        icon: Icon(
                          wishListIds.contains(widget.productId)
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_sharp,
                          color: ColorPallette.redColor,
                          size: 30.r,
                        ));
              },
            ))
      ],
    );
  }
}
