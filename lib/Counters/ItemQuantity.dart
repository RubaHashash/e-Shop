import 'package:flutter/cupertino.dart';

class ItemQuantity with ChangeNotifier{

  int _numberOfItems = 1;

  int get numberOfItems => _numberOfItems;

  display(int no){
    _numberOfItems = no;
    notifyListeners();
  }

  increment(){
    _numberOfItems++;
    notifyListeners();
  }

  decrement(){
    _numberOfItems--;
    notifyListeners();
  }
}