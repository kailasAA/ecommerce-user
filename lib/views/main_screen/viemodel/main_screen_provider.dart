import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  int selectedIndex = 0;
  PageController? pageController;

  void navigateToCartScreen() {
    selectedIndex = 2;
    pageController?.jumpToPage(2);
    notifyListeners();
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
