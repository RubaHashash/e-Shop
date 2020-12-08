import 'package:e_shop_app/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemCounter extends ChangeNotifier{

    int _counter = shopApp.sharedPreferences
        .getStringList("userCart")
        .length - 1;

  int get count => _counter;
}