import 'package:fakestore/model/constants.dart';
import 'package:fakestore/model/errors.dart';
import 'package:fakestore/model/network/StatusController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends FSGetXController {
  String _user = '';
  String _pass = '';

  @override
  void onReady() {
    _validateLogin();
    super.onReady();
  }

  void _validateLogin() async {
    Future.delayed(const Duration(seconds: 3), () {
        _isInitialFirst().then(
              (initial) {
                if (initial) {
                  Get.toNamed('/presentation');
                } else {
                  _isLogged().then(
                    (logged) async {
                      if (logged) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.offAllNamed('/login');
                      }
                    },
                  );
                }
              },
            );

    });
  }

  Future<bool> _isLogged() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _user = preferences.getString(persistence.user) ?? '';
    _pass = preferences.getString(persistence.pass) ?? '';
    return preferences.getBool(persistence.isLogged) ?? false;
  }

  Future<bool> _isInitialFirst() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(persistence.isInitialFirst) ?? true;
  }


}
