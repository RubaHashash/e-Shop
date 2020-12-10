import 'package:e_shop_app/Models/items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
