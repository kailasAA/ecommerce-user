import 'package:ecommerce_user_side/gen/assets.gen.dart';
import 'package:ecommerce_user_side/utils/color_pallette.dart';
import 'package:ecommerce_user_side/utils/font_pallette.dart';
import 'package:ecommerce_user_side/views/cart/view/cart_screen.dart';
import 'package:ecommerce_user_side/views/categories/view/categories.dart';
import 'package:ecommerce_user_side/views/home/view/home_screen.dart';
import 'package:ecommerce_user_side/views/main_screen/viemodel/main_screen_provider.dart';
import 'package:ecommerce_user_side/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    context.read<MainScreenProvider>().pageController = pageController;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainscreenProvider = context.read<MainScreenProvider>();

    List<String> icons = [
      Assets.home1SvgrepoCom,
      Assets.rotateSvgrepoCom,
      Assets.shoppingCartSvgrepoCom,
      Assets.profileCircleSvgrepoCom
    ];
    List<String> bottomnavText = ["Home", "Categories", "Cart", "Profile"];

    List<Widget> screenList = [
      const HomeScreen(),
      const CategoriesScreen(),
      const CartScreen(),
      const ProfileScreen()
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: ColorPallette.scaffoldBgColor,
        body: PageView(
          controller: context.read<MainScreenProvider>().pageController,
          onPageChanged: (value) {
            mainscreenProvider.updateIndex(value);
          },
          children: screenList,
        ),
        bottomNavigationBar: Selector<MainScreenProvider, int>(
          selector: (_, mainScreenProvider) => mainScreenProvider.selectedIndex,
          builder: (context, value, child) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: ColorPallette.scaffoldBgColor,
              enableFeedback: false,
              mouseCursor: SystemMouseCursors.none,
              selectedLabelStyle:
                  FontPallette.headingStyle.copyWith(fontSize: 13.sp),
              showUnselectedLabels: false,
              currentIndex: value,
              iconSize: 20,
              selectedFontSize: 12,
              elevation: 0,
              selectedItemColor: ColorPallette.blackColor,
              unselectedItemColor: ColorPallette.greyColor,
              onTap: (val) {
                mainscreenProvider.updateIndex(val);
                context
                    .read<MainScreenProvider>()
                    .pageController
                    ?.jumpToPage(val);
              },
              items: List.generate(
                bottomnavText.length,
                (index) {
                  return BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      icons[index],
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        ColorPallette.greyColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      icons[index],
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                        ColorPallette.blackColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: bottomnavText[index],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
