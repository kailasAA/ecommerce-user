import 'dart:ui';

import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast(String toastMessage, {Color? toastColor}) {
  Fluttertoast.showToast(
    msg: toastMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: toastColor ?? ColorPallette.blackColor,
    textColor: ColorPallette.whiteColor,
  );
}
