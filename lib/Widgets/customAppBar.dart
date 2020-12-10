import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget{

  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          bottom: bottom,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Palette.darkBlue,
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
          ),
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Palette.lightBlue,
                        ),
                        Positioned(
                          top: 3.0,
                          bottom: 4.0,
                          left: 6.0,
                          child: Consumer<CartItemCounter>(
                              builder: (context, counter, _){
                                return Text(
                                  counter.count.toString(),
                                  style: TextStyle(color: Palette.darkBlue, fontSize: 13.0, fontWeight: FontWeight.w500),
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
    );
  }

  @override
  Size get preferredSize => bottom==null?Size(70, AppBar().preferredSize.height):Size(70, 80+AppBar().preferredSize.height);

}
