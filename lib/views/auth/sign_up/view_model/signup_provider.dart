import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isObscure = true;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  // to signup with email and password
  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      showToast("Signed Up Successfully");
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      showToast("Sign Up was not Successfull");
      print(e.toString());
    }
  }
}
