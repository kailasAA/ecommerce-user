import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  void gotoCartScreen() {
    print("go to cart called");
    pageController.jumpToPage(2);
  }

  void updateIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void reset() {
    selectedIndex = 0;
    notifyListeners();
  }
}
