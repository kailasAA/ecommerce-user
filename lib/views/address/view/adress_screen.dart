import 'package:ecommerce_user_side/common/common_functions.dart/dialog_box.dart';
import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/models/address_model.dart';
import 'package:ecommerce_user_side/views/address/view_model/address_provider.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AdressScreen extends StatefulWidget {
  const AdressScreen({super.key});

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  late User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<AddressProvider>().getAddress(user?.uid ?? "");
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.read<AddressProvider>();
    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorPallette.scaffoldBgColor,
        title: Text(
          "Address",
          style: FontPallette.headingStyle,
        ),
      ),
      body: Selector<AddressProvider, Tuple2<bool, List<AddressModel>>>(
        selector: (p0, p1) => Tuple2(p1.isLoading, p1.addressList),
        builder: (context, value, child) {
          final isLoading = value.item1;
          final addressList = value.item2;
          return isLoading
              ? const LoadingAnimation()
              : addressList.isEmpty
                  ? Center(
                      child: Text(
                      "No addresses found",
                      style: FontPallette.headingStyle,
                    ))
                  : ListView.separated(
                      separatorBuilder: (context, index) => 10.verticalSpace,
                      padding: EdgeInsets.all(15.r),
                      itemCount: addressList.length,
                      itemBuilder: (context, index) {
                        final address = addressList[index];
                        return Container(
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(18.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.name ?? "No name",
                                    style: FontPallette.headingStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    address.addressLine ?? "",
                                    style: FontPallette.headingStyle.copyWith(
                                        color: Colors.white, fontSize: 13.sp),
                                  ),
                                  Text(
                                    address.phoneNumber ?? "",
                                    style: FontPallette.headingStyle.copyWith(
                                        color: Colors.white, fontSize: 13.sp),
                                  ),
                                  Text(
                                    "${address.city ?? ""}, ${address.state ?? ""} - ${address.postalCode ?? ""}",
                                    style: FontPallette.headingStyle.copyWith(
                                        color: Colors.white, fontSize: 13.sp),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  confirmationDialog(
                                    context: context,
                                    content: "Do you want to remove this ?",
                                    onTap: () {
                                      Navigator.pop(context);
                                      addressProvider.deleteAddress(
                                          addressList[index].id ?? "",
                                          user?.uid ?? "");
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteGenerator.addAddressScreen);
        },
        child: SimpleButton(
          width: 100.w,
          height: 40.h,
          borderRadius: 25.r,
          buttonColor: ColorPallette.blackColor,
          childWidget: Text(
            "Add new",
            style: FontPallette.headingStyle
                .copyWith(fontSize: 13.sp, color: ColorPallette.whiteColor),
          ),
        ),
      ),
    );
  }
}
