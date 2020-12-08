import 'dart:async';

import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Widgets/MyDrawer.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                color: Colors.white
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Quick Shop",
                style: TextStyle(fontSize: 55.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Palette.darkBlue),
            actions: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart, color: Palette.darkBlue),
                      onPressed: (){
                        Route route = MaterialPageRoute(builder: (c) => CartPage());
                        Navigator.pushReplacement(context, route);
                      },
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Palette.orange,
                          ),
                          Positioned(
                            top: 3.0,
                            bottom: 4.0,
                            child: Consumer<CartItemCounter>(
                              builder: (context, counter, _){
                                return Text(
                                  counter.count.toString(),
                                  style: TextStyle(color: Palette.darkBlue, fontSize: 12.0, fontWeight: FontWeight.w500),
                                );
                              }
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        drawer: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: MyDrawer(),
        ),
      ),
    );
  }
}
