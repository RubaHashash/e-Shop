import 'package:e_shop_app/config/config.dart';
import 'package:flutter/cupertino.dart';


class CartItemCounter extends ChangeNotifier{

    int _counter = shopApp.sharedPreferences
        .getStringList("userCart")
        .length - 1;

  int get count => _counter;

  Future<void> displayResult() async{
    int _counter = shopApp.sharedPreferences
        .getStringList("userCart")
        .length - 1;

    await Future.delayed(const Duration(microseconds: 100), (){
      notifyListeners();
    });

  }
}