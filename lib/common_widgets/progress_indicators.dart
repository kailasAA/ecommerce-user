import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoadingAnimationStaggeredDotsWave extends StatelessWidget {
  const LoadingAnimationStaggeredDotsWave({
    super.key,
    this.size,
  });
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: ColorPallette.greyColor,
        size: size ?? 40.h,
      ),
    );
  }
}

class ThreeDotLoadingAnimation extends StatelessWidget {
  const ThreeDotLoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.threeRotatingDots(
            color: ColorPallette.blackColor, size: 30.h));
  }
}

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    super.key,
    this.size,
  });
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.hexagonDots(
            color: ColorPallette.greyColor, size: size ?? 30.h));
  }
}
