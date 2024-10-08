import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:ecommerce_user_side/route/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isObscure = true;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> loginWithPasswordAndEmail(
      String email, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (userCredential) {
          user = userCredential.user;
          notifyListeners();
        },
      );
      showToast("Login successfull");
      Navigator.pushNamed(context, RouteGenerator.mainScreen);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      showToast("Login was not successfull");
      print(e.toString());
    }
  }

  // to log out

  Future<void> logOut() async {
    isLoading = true;
    notifyListeners();
    try {
      await firebaseAuth.signOut();
      showToast("Log out was successfull");
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    isLoading = false;
    notifyListeners();
  }
}
