import 'package:fakestore/model/constants.dart';
import 'package:fakestore/model/errors.dart';
import 'package:fakestore/model/network/StatusController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends FSGetXController {
  bool _isCompleteForm = false;
  bool _isVisibilityPass = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  bool get isCompleteForm => _isCompleteForm;
  bool get isVisibilityPass => _isVisibilityPass;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get controllerName => _controllerName;
  TextEditingController get controllerPass => _controllerPass;

  void changePasswordVisibility() {
    _isVisibilityPass = !_isVisibilityPass;
    update(['Password']);
  }

  String? validateEmail(String? value) {
    if (value!.trim().isEmpty) {
      return "Enter your email.";
    } else if (!GetUtils.isEmail(value)) {
      return "Enter a valid email.";
    }
    return null;
  }

  String? validatePass(String? value) {
    if (value!.trim().isEmpty) {
      return "Enter your password.";
    }
    if (value.trim().length < 3) {
      return "Your password must be at least 3 digits long.";
    }
    return null;
  }

  void onChangeUserName(String? value) {
    _validateBtnContinuar();
  }

  void onChangePass(String? value) {
    _validateBtnContinuar();
  }

  void _validateBtnContinuar() {
    if (_formKey.currentState!.validate()) {
      _isCompleteForm = true;
    } else {
      _isCompleteForm = false;
    }
    update(['BtnLogin']);
  }

  void onLogin() async {
    _isLoading = true;
    update();
    FocusScope.of(Get.context!).requestFocus(FocusNode());


    FirebaseAuth.instance.signInWithEmailAndPassword(email: _controllerName.text.trim(), password: _controllerPass.text.trim()).then((value) {
      _loginFinish(true);
      Get.offAllNamed('/home');
    }).onError((error, stackTrace) {
      _loginFinish(false);
      Errors().errors(401,message: 'Somthing Went Wrong');
    });

    _isLoading = false;
    update();
  }

  void goToSingIn() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    Get.toNamed('/singin');
  }

  void _loginFinish(bool success) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(persistence.isLogged, success);
    preferences.setBool(persistence.isInitialFirst, false);
    preferences.setString(persistence.user, _controllerName.text.trim());
    preferences.setString(persistence.pass, _controllerPass.text.trim());
  }
}
