import 'package:fakestore/model/constants.dart';
import 'package:fakestore/model/errors.dart';
import 'package:fakestore/model/network/StatusController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingInController extends FSGetXController {
  bool _isCompleteForm = false;
  bool _isVisibilityPass = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  bool get isCompleteForm => _isCompleteForm;
  bool get isVisibilityPass => _isVisibilityPass;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get controllerName => _controllerName;
  TextEditingController get controllerEmail => _controllerEmail;
  TextEditingController get controllerPass => _controllerPass;

  void changePasswordVisibility() {
    _isVisibilityPass = !_isVisibilityPass;
    update(['Password']);
  }

  String? validateUserName(String? value) {
    if (value!.trim().isEmpty) {
      return "Enter your username.";
    } else if (!GetUtils.isUsername(value)) {
      return "Enter a valid user.";
    }
    return null;
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
    if (value.trim().length < 8) {
      return "Your password must be at least 8 digits long.";
    }
    return null;
  }

  void onChangeUserName(String? value) {
    _validateBtnContinuar();
  }

  void onChangeEmail(String? value) {
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
    update(['BtnSingIn']);
  }

  void onSingIn() async {
    _isLoading = true;
    update();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: _controllerEmail.text.trim(), password: _controllerPass.text.trim()).then((value) {
      _loginFinish(true);
      Get.offAllNamed('/home');
    }).onError((error, stackTrace) {
      Errors().errors(401,message: 'Somthing Went Wrong');
    });


    _isLoading = false;
    update();
  }
  void _loginFinish(bool success) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(persistence.isLogged, success);
    preferences.setBool(persistence.isInitialFirst, false);
    preferences.setString(persistence.user, _controllerName.text.trim());
    preferences.setString(persistence.pass, _controllerPass.text.trim());
  }
}
