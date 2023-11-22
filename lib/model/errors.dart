
import 'package:get/get.dart';

class Errors{

  void errors(int code,{String message = ''}){
    switch(code){
      case 401:
        Get.snackbar('Oops!', message.isEmpty ? 'Somthing Went Wrong' : message);
        break;
      case 404:
        Get.snackbar('Oops!', message.isEmpty ? 'Somthing Went Wrong' : message);
        break;
      case 0:
        Get.snackbar('Oops!', message.isEmpty ? 'Somthing Went Wrong' : message);
        break;
    }
  }
}