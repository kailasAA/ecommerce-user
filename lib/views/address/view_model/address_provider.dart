import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/common/common_functions.dart/show_toast.dart';
import 'package:ecommerce_user_side/views/address/model/address_model.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  AddressModel? selectedAdress;
  bool isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<AddressModel> addressList = [];
  // User? user = FirebaseAuth.instance.currentUser;
  bool isValidated = true;
  bool isNameVerified = true;
  bool isPhoneNumberVerified = true;
  bool isAdressLineValidated = true;
  bool isCityValidated = true;
  bool isStateValidated = true;
  bool isPostalCodeValidated = true;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneNoTextController = TextEditingController();
  final TextEditingController cityTextController = TextEditingController();
  final TextEditingController postalCodeTextController =
      TextEditingController();
  final TextEditingController stateTextController = TextEditingController();
  final TextEditingController adressLineTextController =
      TextEditingController();

  void validate() {
    validateName(nameTextController.text);
    validatePhoneNumber(phoneNoTextController.text);
    validateAdressLine(adressLineTextController.text);
    validateCity(cityTextController.text);
    validateState(stateTextController.text);
    validatePostalCode(stateTextController.text);
    if (isNameVerified &&
        isAdressLineValidated &&
        isPhoneNumberVerified &&
        isCityValidated &&
        isStateValidated &&
        isPostalCodeValidated) {
      isValidated = true;
      notifyListeners();
    } else {
      isValidated = false;
      notifyListeners();
    }
  }

  void validateName(String value) {
    if (value.length < 3 || nameTextController.text.isEmpty) {
      isNameVerified = false;
      notifyListeners();
    } else {
      isNameVerified = true;
      notifyListeners();
    }
  }

  void validatePhoneNumber(String value) {
    if (value.length != 10 || phoneNoTextController.text.isEmpty) {
      isPhoneNumberVerified = false;
      notifyListeners();
    } else {
      isPhoneNumberVerified = true;
      notifyListeners();
    }
  }

  void validateAdressLine(String value) {
    if (value.length < 4 || adressLineTextController.text.isEmpty) {
      isAdressLineValidated = false;
      notifyListeners();
    } else {
      isAdressLineValidated = true;
      notifyListeners();
    }
  }

  void validateCity(String value) {
    if (value.length < 4 || cityTextController.text.isEmpty) {
      isCityValidated = false;
      notifyListeners();
    } else {
      isCityValidated = true;
      notifyListeners();
    }
  }

  void validateState(String value) {
    if (value.length < 4 || stateTextController.text.isEmpty) {
      isStateValidated = false;
      notifyListeners();
    } else {
      isStateValidated = true;
      notifyListeners();
    }
  }

  void validatePostalCode(String value) {
    if (value.length != 6 || postalCodeTextController.text.isEmpty) {
      isPostalCodeValidated = false;
      notifyListeners();
    } else {
      isPostalCodeValidated = true;
      notifyListeners();
    }
  }

  Future<void> addAdress(String userId) async {
    try {
      if (isValidated) {
        final adress = AddressModel(
            addressLine: adressLineTextController.text,
            city: cityTextController.text,
            name: nameTextController.text,
            phoneNumber: phoneNoTextController.text,
            postalCode: postalCodeTextController.text,
            state: stateTextController.text);
        isLoading = true;
        notifyListeners();
        final docRef = await firestore
            .collection('users')
            .doc(userId)
            .collection("address")
            .add(adress.toJson());
        final id = docRef.id;
        firestore
            .collection('users')
            .doc(userId)
            .collection("address")
            .doc(id)
            .update({'id': id});

        adressLineTextController.clear();
        cityTextController.clear();
        nameTextController.clear();
        phoneNoTextController.clear();
        postalCodeTextController.clear();
        stateTextController.clear();
        showToast("Address added successfully");
        isLoading = false;
        notifyListeners();
        getAddress(userId);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      showToast("Address was not added");
      print("add adress failed");
    }
  }

  Future<void> getAddress(String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await firestore
          .collection('users')
          .doc(userId)
          .collection("address")
          .get();
      final doc = data.docs;
      final list = doc.map(
        (address) {
          return AddressModel.fromJson(address.data());
        },
      ).toList();
      addressList = list;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String adressId, String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection("address")
          .doc(adressId)
          .delete();
      getAddress(userId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void changeSelectedAdress(AddressModel adress) {
    selectedAdress = adress;
    notifyListeners();
  }
}
