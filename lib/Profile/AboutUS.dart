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
                          child: Text("About Us",style: TextStyle(color: Colors.white, fontSize: 38, fontFamily: "PatrickHand"))
                      ),
                      SizedBox(height: 12,),
                      Text("Online shopping is a form of electronic commerce which allows consumers to directly "
                          "buy goods or services from a seller over the Internet using a web browser or a mobile app. "
                          "Consumers find a product of interest by visiting the website of the retailer directly or by "
                          "searching among alternative vendors using a shopping search engine, which displays the same "
                          "product's availability and pricing at different e-retailers. As of 2020, customers can shop "
                          "online using a range of different computers and devices, including desktop computers, laptops, "
                          "tablet computers and smartphones.",
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
