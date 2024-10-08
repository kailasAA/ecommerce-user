import 'package:ecommerce_user_side/common_widgets/progress_indicators.dart';
import 'package:ecommerce_user_side/common_widgets/textform_field.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/address/view_model/address_provider.dart';
import 'package:ecommerce_user_side/views/auth/login/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AddAdressScreen extends StatelessWidget {
  const AddAdressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final adressProvider = context.read<AddressProvider>();

    return Scaffold(
      backgroundColor: ColorPallette.scaffoldBgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorPallette.scaffoldBgColor,
        centerTitle: true,
        title: Text(
          "Add Adress",
          style: FontPallette.headingStyle,
        ),
      ),
      body: Selector<AddressProvider, Tuple2<bool, bool>>(
        selector: (p0, p1) => Tuple2(p1.isLoading, p1.isValidated),
        builder: (context, value, child) {
          final isLoading = value.item1;
          final isValidated = value.item2;

          return isLoading
              ? const LoadingAnimation()
              : ListView(
                  padding: EdgeInsets.all(20.r),
                  children: [
                    Selector<AddressProvider, TextEditingController>(
                      selector: (p0, p1) => p1.nameTextController,
                      builder: (context, nameTextController, child) {
                        return NuemorphicTextField(
                          prefixWidget: Icon(
                            Icons.person,
                            size: 20.r,
                          ),
                          headingText: "Name",
                          hintText: "Enter your name",
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            adressProvider.validateName(value);
                          },
                          textEditingController: nameTextController,
                        );
                      },
                    ),
                    5.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<AddressProvider, bool>(
                            selector: (p0, p1) => p1.isNameVerified,
                            builder: (context, isNameVerified, child) {
                              return !isNameVerified && !isValidated
                                  ? SizedBox(
                                      height: 20.h,
                                      child: Text(
                                        "Please give a valid name",
                                        style: FontPallette.subtitleStyle
                                            .copyWith(
                                                color: ColorPallette.redColor,
                                                fontSize: 9.sp),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    );
                            }),
                      ],
                    ),
                    Selector<AddressProvider, TextEditingController>(
                        selector: (p0, p1) => p1.phoneNoTextController,
                        builder: (context, phoneNoTextController, child) {
                          return NuemorphicTextField(
                            prefixWidget: Icon(
                              Icons.phone,
                              size: 20.r,
                            ),
                            headingText: "Phone Number",
                            hintText: "Enter contact number",
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              adressProvider.validatePhoneNumber(val);
                            },
                            textEditingController: phoneNoTextController,
                          );
                        }),
                    5.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<AddressProvider, bool>(
                            selector: (p0, p1) => p1.isPhoneNumberVerified,
                            builder: (context, isPhoneNumberVerified, child) {
                              return !isPhoneNumberVerified && !isValidated
                                  ? SizedBox(
                                      height: 20.h,
                                      child: Text(
                                        "Please give a valid number",
                                        style: FontPallette.subtitleStyle
                                            .copyWith(
                                                color: ColorPallette.redColor,
                                                fontSize: 9.sp),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    );
                            }),
                      ],
                    ),
                    Selector<AddressProvider, TextEditingController>(
                        selector: (p0, p1) => p1.adressLineTextController,
                        builder: (context, adressLineTextController, child) {
                          return NuemorphicTextField(
                            prefixWidget: Icon(
                              Icons.place,
                              size: 20.r,
                            ),
                            headingText: "AdressLine",
                            hintText: "Enter your AdressLine",
                            keyboardType: TextInputType.name,
                            onChanged: (val) {
                              adressProvider.validateAdressLine(val);
                            },
                            textEditingController: adressLineTextController,
                          );
                        }),
                    5.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<AddressProvider, bool>(
                            selector: (p0, p1) => p1.isAdressLineValidated,
                            builder: (context, isAdressLineValidated, child) {
                              return !isAdressLineValidated && !isValidated
                                  ? SizedBox(
                                      height: 20.h,
                                      child: Text(
                                        "Please give a valid address",
                                        style: FontPallette.subtitleStyle
                                            .copyWith(
                                                color: ColorPallette.redColor,
                                                fontSize: 9.sp),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    );
                            }),
                      ],
                    ),
                    Selector<AddressProvider, TextEditingController>(
                        selector: (p0, p1) => p1.cityTextController,
                        builder: (context, cityTextController, child) {
                          return NuemorphicTextField(
                            prefixWidget: Icon(
                              Icons.location_city,
                              size: 20.r,
                            ),
                            headingText: "City",
                            hintText: "Enter your city name",
                            keyboardType: TextInputType.name,
                            onChanged: (val) {
                              adressProvider.validateCity(val);
                            },
                            textEditingController: cityTextController,
                          );
                        }),
                    5.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<AddressProvider, bool>(
                            selector: (p0, p1) => p1.isCityValidated,
                            builder: (context, isCityValidated, child) {
                              return !isCityValidated && !isValidated
                                  ? SizedBox(
                                      height: 20.h,
                                      child: Text(
                                        "Please give a valid city name",
                                        style: FontPallette.subtitleStyle
                                            .copyWith(
                                                color: ColorPallette.redColor,
                                                fontSize: 9.sp),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    );
                            }),
                      ],
                    ),
                    Selector<AddressProvider, TextEditingController>(
                        selector: (p0, p1) => p1.stateTextController,
                        builder: (context, stateTextController, child) {
                          return NuemorphicTextField(
                            prefixWidget: Icon(
                              Icons.place,
                              size: 20.r,
                            ),
                            headingText: "State",
                            hintText: "Enter name of the state",
                            keyboardType: TextInputType.name,
                            onChanged: (val) {
                              adressProvider.validateState(val);
                            },
                            textEditingController: stateTextController,
                          );
                        }),
                    5.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<AddressProvider, bool>(
                            selector: (p0, p1) => p1.isStateValidated,
                            builder: (context, isStateValidated, child) {
                              return !isStateValidated && !isValidated
                                  ? SizedBox(
                                      height: 20.h,
                                      child: Text(
                                        "Please give a valid state name",
                                        style: FontPallette.subtitleStyle
                                            .copyWith(
                                                color: ColorPallette.redColor,
                                                fontSize: 9.sp),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    );
                            }),
                      ],
                    ),
                    Selector<AddressProvider, TextEditingController>(
                        selector: (p0, p1) => p1.postalCodeTextController,
                        builder: (context, postalCodeTextController, child) {
                          return NuemorphicTextField(
                            prefixWidget: Icon(
                              Icons.location_on,
                              size: 20.r,
                            ),
                            headingText: "Postal Code",
                            hintText: "Enter your Pin Code",
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              adressProvider.validatePostalCode(val);
                            },
                            textEditingController: postalCodeTextController,
                          );
                        }),
                    5.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<AddressProvider, bool>(
                            selector: (p0, p1) => p1.isPostalCodeValidated,
                            builder: (context, isPostalCodeValidated, child) {
                              return !isPostalCodeValidated && !isValidated
                                  ? SizedBox(
                                      height: 20.h,
                                      child: Text(
                                        "Please give a valid postal code",
                                        style: FontPallette.subtitleStyle
                                            .copyWith(
                                                color: ColorPallette.redColor,
                                                fontSize: 9.sp),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    );
                            }),
                      ],
                    ),
                    15.verticalSpace,
                    Selector<AddressProvider, bool>(
                      selector: (p0, p1) => p1.isValidated,
                      builder: (context, isValidated, child) {
                        return GestureDetector(
                          onTap: () {
                            adressProvider.validate();
                            if (isValidated) {
                              adressProvider.addAdress(user?.uid ?? "");
                            }
                          },
                          child: SimpleButton(
                            height: 50.h,
                            width: 130.w,
                            childWidget: Center(
                              child: Text(
                                "Add Adress",
                                style: FontPallette.headingStyle.copyWith(
                                    fontSize: 13.sp,
                                    color: ColorPallette.whiteColor),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }
}
