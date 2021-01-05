import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan[800], Palette.darkBlue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft
                ),
              ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16),
                  child: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white.withOpacity(0.9),
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),
                Stack(
                  children: [
                    Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.shopping_bag, color: Palette.orange, size: 300,),
                  ),

                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.shopping_bag, color: Palette.lightBlue , size: 300,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:80.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.shopping_bag, color: Colors.white , size: 300,),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("About Us",style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: "Cabin"))
                      ),
                      SizedBox(height: 12,),
                      Text("Welcome to Shopick, your number one source for all shopping."
                          "We're dedicated to give you the best of products, with a focus on dependability, customer service and uniqueness. "
                          "Shopick aim is to inspire its clients by offering at the click of a button and a tap of finger an exclusive "
                          "shopping experience and excellent customer support with the best assortment of renowned and first-class brands. "
                          "Shopick carries a diverse and exciting palette of international and local brands. You can find anything you need. "
                          "We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, "
                          "please don't hesitate to contact us."
                          "Available on Android and iOS for free",
                        style: TextStyle(color: Colors.white, fontSize: 17),),
                    ],
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
