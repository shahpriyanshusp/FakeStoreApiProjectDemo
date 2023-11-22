import 'package:fakestore/model/constants.dart';
import 'package:fakestore/model/network/StatusController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresentationController extends FSGetXController {

  void goToLogin() {
    Get.toNamed('/login');
  }
}
