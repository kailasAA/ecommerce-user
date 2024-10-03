import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/models/variant_model.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key, required this.variant});
  final Variant? variant;
  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int page = 0;
  int nextPage = 0;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _listenController();
        startAutoScroll();
      },
    );
    super.initState();
  }

  void _listenController() {
    pageController.addListener(() {
      page = pageController.page!.round();
      nextPage = page + 1;
    });
  }

  void startAutoScroll() {
    Future.delayed(const Duration(milliseconds: 300)).then(
      (value) {
        if (pageController.hasClients && mounted) {
          nextPage = page + 1;
          Future.delayed(const Duration(
            seconds: 2,
          )).then(
            (value) {
              if (pageController.hasClients && mounted) {
                pageController
                    .animateToPage(nextPage,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linearToEaseOut)
                    .then(
                      (value) => startAutoScroll(),
                    );
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.variant?.imageUrlList ?? []).isNotEmpty
        ? Stack(
            children: [
              SizedBox(
                height: 220.h,
                width: double.infinity,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    final currentIndex =
                        index % (widget.variant?.imageUrlList ?? []).length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.r),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.variant?.imageUrlList?[currentIndex] ??
                                    "",
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
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
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: Container(
                    height: 35.r,
                    width: 35.r,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: ColorPallette.lightGreyColor),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: ColorPallette.redColor,
                          size: 20.r,
                        )),
                  ))
            ],
          )
        : const SizedBox();
  }
}
