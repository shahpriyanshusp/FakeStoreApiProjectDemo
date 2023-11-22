import 'dart:convert';

import 'package:fakestore/model/constants.dart';
import 'package:fakestore/model/network/StatusController.dart';
import 'package:fakestore/model/products/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends FSGetXController {
  List<Product> _products = [];
  List<dynamic> productsfavourite = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  @override
  void onInit() {
    _getProducts();

    super.onInit();
  }

  Future<void> _getProducts() async {
    JsonResponseList response = await getProductos(
      EndPoint.products,
      params: {},
    );

    if (response.statusCode == 200) {
      _products = response.response;
      update(['ListProducts']);
    }
    Retrivefavourite();
    _isLoading = false;
    update();

    debugPrint('$response');
  }

  void onTapFavourite(int index) {
    if(productsfavourite.contains(products[index].id.toString())){
      productsfavourite.remove(products[index].id.toString());
      Savefavourite();
    }
    else{
      productsfavourite.add(products[index].id.toString());
      Savefavourite();
    }
    update();

  }

  Future<void> Savefavourite() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(persistence.favourite, jsonEncode(productsfavourite));
  }

  Future<void> Retrivefavourite() async {
    final prefs = await SharedPreferences.getInstance();
   String checking= prefs.getString(persistence.favourite) ?? "";
   if(checking!=""){
     productsfavourite=jsonDecode(checking.toString())?? [];
   }

  }

  void onCloseSession() async{
    SharedPreferences.getInstance().then((preferences) async{
      preferences.setBool(persistence.isLogged, false);
      preferences.setString(persistence.user, '');
      preferences.setString(persistence.pass, '');

      preferences.setString(persistence.favourite, "");
      final FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        await _auth.signOut();
      } catch (e) {
        print('Error signing out: $e');
      }
      Get.offAllNamed('/login');
    });
  }

  void goToDetailProduct(String id, Product item) {
    Get.toNamed('/detail_product', arguments: {'id': id, 'product': item});
  }
}
